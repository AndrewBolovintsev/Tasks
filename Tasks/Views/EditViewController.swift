//
//  EditViewController.swift
//  Tasks
//
//  Created by Andrew on 2.07.23.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    var task: Tasks? // Создание переменной task типа Tasks
    
    // Создание ленивой переменной persistentContainer типа NSPersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tasks")  // Инициализация контейнера с именем "Tasks"
        // Загрузка хранилища Core Data
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Не удалось загрузить хранилище Core Data: \(error), \(error.userInfo)") // Обработка ошибки при загрузке хранилища Core Data
            }
        })
        return container // Возврат контейнера
    }()
    
    // Создание ленивой переменной managedObjectContext типа NSManagedObjectContext
    lazy var managedObjectContext: NSManagedObjectContext = { return persistentContainer.viewContext }() // Возвращение контекста просмотра persistentContainer
    
    // MARK: - Outlet
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var descriptView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        enterOutlet() // Вывод значений на экран
        deactivatorSave() // Наблюдатель
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))) // Добавление жеста тапа на экран
    }
    
    // MARK: - Action
    @IBAction func priorityAction(_ sender: Any) {
        // Устанавливаем цвет выбранного сегмента в зависимости от значения атрибута "priority"
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
            newTask.setValue(nameTF.text, forKey: "name") // Задаем значение атрибута "name" новой задачи, равное тексту из текстового поля nameTF
            newTask.setValue(Int16(prioritySegmented.selectedSegmentIndex), forKey: "priority") // Задаем значение атрибута "priority" новой задачи, равное индексу выбранного сегмента в сегментированном контроле prioritySegmented, приведенному к типу Int16
            newTask.setValue(descriptView.text, forKey: "descript") // Задаем значение атрибута "descript" новой задачи, равное тексту из текстового поля descriptView
        }
        
        // Сохраняем изменения в контексте Core Data
        do {
            try managedObjectContext.save() // Сохраняем изменения в контексте Core Data
            navigationItem.rightBarButtonItem?.isEnabled = false // Возвращаемся на предыдущий экран
        } catch let error as NSError {
            print("Не удалось сохранить контекст Core Data: \(error), \(error.userInfo)") // Обработка ошибки при сохранении контекста Core Data
        }
    }
    
    // MARK: - Method called when tapping on the screen
    @objc func tapGesture() {
        nameTF.resignFirstResponder() // Скрытие клавиатуры для поля ввода названия задачи
        descriptView.resignFirstResponder() // Скрытие клавиатуры для поля ввода описания задачи
    }
    
    // MARK: - Method for handling changes in the nameTF field
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkIfFieldsChanged()
    }
    
    // MARK: - Method for handling changes in the segmented control prioritySegmented
    @objc func segmentedControlValueChanged(_ segmentedControl: UISegmentedControl) {
        checkIfFieldsChanged()
    }
    
    // MARK: - Method for handling changes in the descriptView field
    @objc func textViewDidChange(_ notification: Notification) {
        checkIfFieldsChanged()
    }
    
    //  MARK: - Method for displaying values ​​on the screen
    func enterOutlet() {
        // Проверяем, есть ли уже объект NSManagedObject для данной задачи
        if let task = task {
            // Заполняем поля данными из объекта NSManagedObject
            nameTF.text = task.name // Задаем текстовому полю nameTF значение атрибута "name" задачи
            prioritySegmented.selectedSegmentIndex = Int(task.priority) // Задаем выбранному сегменту в сегментированном контроле prioritySegmented индекс, равный значению атрибута "priority" задачи, приведенному к типу Int
            // Устанавливаем цвет выбранного сегмента в зависимости от значения атрибута "priority"
            if prioritySegmented.selectedSegmentIndex == 0 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9774648547, green: 0.2064308822, blue: 0.1888276637, alpha: 1) }
            else if prioritySegmented.selectedSegmentIndex == 1 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9826945662, green: 0.5444327593, blue: 0.1365438104, alpha: 1) }
            else { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.1812253594, green: 0.7537381053, blue: 0.3327225149, alpha: 1) }
            descriptView.text = task.descript // Задаем текстовому полю descriptView значение атрибута "descript" задачи
        }
    }
    
    // MARK: - Method for checking changes in fields
    func checkIfFieldsChanged() {
        if let task = task {
            let nameChanged = nameTF.text != task.value(forKey: "name") as? String
            let priorityChanged = Int16(prioritySegmented.selectedSegmentIndex) != task.value(forKey: "priority") as? Int16
            let descriptChanged = descriptView.text != task.value(forKey: "descript") as? String
            
            navigationItem.rightBarButtonItem?.isEnabled = nameChanged || priorityChanged || descriptChanged // Активируем или деактивируем кнопку "Save" в зависимости от наличия изменений
        }
    }
    
    // MARK: - Method of observers
    func deactivatorSave() {
        // Добавляем наблюдателей для свойств
        nameTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        prioritySegmented.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewDidChange(_:)), name: UITextView.textDidChangeNotification, object: descriptView)
        
        // Деактивируем кнопку "Save" при запуске
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
}
