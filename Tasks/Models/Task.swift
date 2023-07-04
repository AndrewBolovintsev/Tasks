//
//  Task.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import CoreData
import UIKit

class Task {

    var name: String
    var priority: Int
    var performance: Bool
    var date: String
    var descript: String
        
    init(name: String, priority: Int, performance: Bool, date: String, descript: String) {
        self.name = name
        self.priority = priority
        self.performance = performance
        self.date = date
        self.descript = descript
    }
    
    func saveToCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Tasks", in: managedContext)!
        
        let task = NSManagedObject(entity: entity, insertInto: managedContext)
        
        task.setValue(name, forKey: "name")
        task.setValue(priority, forKey: "priority")
        task.setValue(performance, forKey: "performance")
        task.setValue(date, forKey: "date")
        task.setValue(descript, forKey: "descript")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    static func dateСheck() {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateText = dateFormatter.string(from: date)
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Tasks")
        do {
            let tasks = try managedContext.fetch(fetchRequest)
            for task in tasks {
                if task.value(forKey: "date") as! String != dateText {
                    managedContext.delete(task)
                    try! managedContext.save()
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
