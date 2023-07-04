//
//  ViewController.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit
import CoreData

class ViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var addOutlet: UIBarButtonItem! 
    
    var fetchedResultsController:NSFetchedResultsController = {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Tasks> = Tasks.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "priority", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "priority >= 0 AND priority <= 2")
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        Task.dateСheck()
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
        }
        
        if segue.identifier == "editVC" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let editVC = segue.destination as! EditViewController
                let task = fetchedResultsController.object(at: indexPath)
                editVC.task = task
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        tableView.setEditing(editing, animated: animated)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections { return sections[section].numberOfObjects }
        else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let task = fetchedResultsController.object(at: indexPath)
            let context = fetchedResultsController.managedObjectContext
            context.delete(task)
            
            do {
                try context.save()
                fetch()
            }
            catch { print(error) }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let task = fetchedResultsController.object(at: indexPath)
        cell.task = task

        return cell
    }
    
    func fetch() {
        do { try fetchedResultsController.performFetch() }
        catch { print(error) }
        
        for cell in tableView.visibleCells {
            if let taskCell = cell as? TaskTableViewCell {
                taskCell.configureCell()
            }
        }
        
        tableView.reloadData()
    }
}

extension ViewController: AddTaskDelegate {
    
    func didAddTask(_ task: Task) {
        fetch()
        
        tableView.reloadData()
    }
}
