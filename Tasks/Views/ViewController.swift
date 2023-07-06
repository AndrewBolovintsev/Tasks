//
//  ViewController.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: - Outlet
    @IBOutlet weak var addOutlet: UIBarButtonItem!
    
    // MARK: - Variable for getting and displaying data from the database
    var fetchedResultsController:NSFetchedResultsController = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "priority >= 0 AND priority <= 2")
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: - Method called before the view becomes visible
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        Task.dateСheck() // Проверка даты задач
        navigationItem.leftBarButtonItem = editButtonItem // Установка кнопки редактирования в левой части навигационного бара
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)  // Установка цвета кнопки редактирования
        fetch() // Получение и отображение данных из базы данных
    }
    
    // MARK: - Method that returns the number of rows in a table section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections { return sections[section].numberOfObjects }
        else { return 0 }
    }
    
    // MARK: - Method that determines if a table row can be edited
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: - Method called when editing a table row
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // Если стиль редактирования равен .delete (удаление)
        if editingStyle == .delete {
            
            let task = fetchedResultsController.object(at: indexPath) // Получение объекта задачи по индексу indexPath из fetchedResultsController
            let context = fetchedResultsController.managedObjectContext // Получение контекста управляемого объекта из fetchedResultsController
            context.delete(task) // Удаление задачи из контекста управляемого объекта
            
            do {
                try context.save() // Сохранение контекста управляемого объекта
                fetch() // Получение и отображение данных из базы данных
            }
            catch { print(error) }
        }
    }
    
    // MARK: - Method that returns a cell for a table row
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let task = fetchedResultsController.object(at: indexPath)
        cell.task = task
        
        return cell
    }
    
    // MARK: - Switch to another screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Если переход на экран добавления задачи
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
        }
        
        // Если переход на экран редактирования задачи
        if segue.identifier == "editVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let editVC = segue.destination as! EditViewController
                let task = fetchedResultsController.object(at: indexPath) // Получение объекта задачи по индексу indexPath из fetchedResultsController
                editVC.task = task
            }
        }
    }
    
    // MARK: - Method called when entering edit mode
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }
    
    // MARK: - Method for getting and displaying data from the database
    func fetch() {
        do { try fetchedResultsController.performFetch() } // Выполнение запроса на получение данных из базы данных
        catch { print(error) }
        
        // Обновление ячеек таблицы
        for cell in tableView.visibleCells {
            if let taskCell = cell as? TaskTableViewCell {
                taskCell.configureCell()
            }
        }
        
        tableView.reloadData() // Перезагрузка таблицы
    }
}

// Расширение для реализации методов делегата AddTaskDelegate
extension ViewController: AddTaskDelegate {
    // Метод, вызываемый после добавления задачи
    func didAddTask(_ task: Task) {
        fetch() // Получение и отображение данных из базы данных
        tableView.reloadData() // Перезагрузка таблицы
    }
}
