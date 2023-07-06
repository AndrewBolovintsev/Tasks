//
//  Task.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import CoreData
import UIKit

class Task {
    
    // MARK: - Storage variable
    var name: String
    var priority: Int
    var performance: Bool
    var date: String
    var descript: String
    
    // MARK: - Variable initialization
    init(name: String, priority: Int, performance: Bool, date: String, descript: String) {
        self.name = name
        self.priority = priority
        self.performance = performance
        self.date = date
        self.descript = descript
    }
    
    // MARK: - Function for saving data in Core Data
    func saveToCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return } // Получение ссылки на AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext // Получение контекста управляемого объекта
        
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContext)! // Создание сущности "Tasks"
        let task = NSManagedObject(entity: entity, insertInto: managedContext) // Создание нового объекта NSManagedObject
        
        // Установка значения для ключа в объекте task
        task.setValue(name, forKey: "name")
        task.setValue(priority, forKey: "priority")
        task.setValue(performance, forKey: "performance")
        task.setValue(date, forKey: "date")
        task.setValue(descript, forKey: "descript")
        
        do {
            try managedContext.save() // Сохранение контекста управляемого объекта
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)") // Вывод ошибки, если сохранение не удалось
        }
    }
    
    // MARK: - Function to check the date
    static func dateСheck() {
        let date = Date() // Получение текущей даты
        let dateFormatter = DateFormatter() // Создание объекта DateFormatter
        dateFormatter.dateFormat = "dd.MM.YYYY" // Установка формата даты
        let dateText = dateFormatter.string(from: date) // Преобразование даты в строку с заданным форматом
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return } // Получение ссылки на AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext // Получение контекста управляемого объекта
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")  // Создание запроса для получения объектов "Tasks"
        do {
            let tasks = try managedContext.fetch(fetchRequest) // Получение массива объектов "Tasks"
            for task in tasks {
                // Проверка, если дата задачи не равна текущей дате
                if task.value(forKey: "date") as! String != dateText {
                    managedContext.delete(task) // Удаление задачи из контекста управляемого объекта
                    try! managedContext.save() // Сохранение контекста управляемого объекта
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")  // Вывод ошибки, если запрос не удалось выполнить
        }
    }
} 
