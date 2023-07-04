//
//  EditViewController.swift
//  Tasks
//
//  Created by Andrew on 2.07.23.
//

import UIKit
import CoreData

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var task: Tasks?
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var descriptView: UITextView!
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Обработка ошибки при загрузке хранилища Core Data
                fatalError("Не удалось загрузить хранилище Core Data: \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var managedObjectContext: NSManagedObjectContext = { return persistentContainer.viewContext }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if let task = task {
            
            nameTF.text = task.name
            
            prioritySegmented.selectedSegmentIndex = Int(task.priority)
            if prioritySegmented.selectedSegmentIndex == 0 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9774648547, green: 0.2064308822, blue: 0.1888276637, alpha: 1) }
            else if prioritySegmented.selectedSegmentIndex == 1 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9826945662, green: 0.5444327593, blue: 0.1365438104, alpha: 1) }
            else { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.1812253594, green: 0.7537381053, blue: 0.3327225149, alpha: 1) }
            
            descriptView.text = task.descript
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
                view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func priorityAction(_ sender: Any) {
        if prioritySegmented.selectedSegmentIndex == 0 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9774648547, green: 0.2064308822, blue: 0.1888276637, alpha: 1) }
        else if prioritySegmented.selectedSegmentIndex == 1 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9826945662, green: 0.5444327593, blue: 0.1365438104, alpha: 1) }
        else { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.1812253594, green: 0.7537381053, blue: 0.3327225149, alpha: 1) }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        // Проверяем, есть ли уже объект NSManagedObject для данной задачи
        if let task = task {
            // Обновляем значения атрибутов объекта NSManagedObject
            task.name = nameTF.text
            task.priority = Int16(prioritySegmented.selectedSegmentIndex)
            task.descript = descriptView.text
        } else {
            // Создаем новый объект NSManagedObject для хранения данных
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Tasks", in: managedObjectContext) else {
                // Обработка ошибки при создании объекта NSManagedObject
                fatalError("Не удалось создать объект NSManagedObject")
            }

            let newTask = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)

            // Устанавливаем значения атрибутов нового объекта NSManagedObject
            newTask.setValue(nameTF.text, forKey: "name")
            newTask.setValue(Int16(prioritySegmented.selectedSegmentIndex), forKey: "priority")
            newTask.setValue(descriptView.text, forKey: "descript")
        }
        
        // Сохраняем изменения в контексте Core Data
        do {
            try managedObjectContext.save()
            navigationItem.rightBarButtonItem?.isEnabled = false
        } catch let error as NSError {
            // Обработка ошибки при сохранении контекста Core Data
            print("Не удалось сохранить контекст Core Data: \(error), \(error.userInfo)")
        }
    }
    
    @objc func tapGesture() {
        nameTF.resignFirstResponder()
        descriptView.resignFirstResponder()
    }
}
