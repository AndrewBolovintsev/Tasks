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
        fetch()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let addVC = segue.destination as? AddViewController {
            addVC.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = fetchedResultsController.object(at: indexPath)
            let context = fetchedResultsController.managedObjectContext
            context.delete(task)
            do {
                try context.save()
                fetch()
            } catch {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        
        let task = fetchedResultsController.object(at: indexPath)
        cell.task = task

        return cell
    }
    
    func fetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error)
        }
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
