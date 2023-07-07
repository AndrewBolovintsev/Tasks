//
//  AddViewController.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
    func didAddTask(_ task: Task) // Протокол делегата для добавления задачи
}

class AddViewController: UIViewController {
    
    weak var delegate: AddTaskDelegate? // Ссылка на делегата
    
    // MARK: - Outlet
    @IBOutlet weak var nameTaskTF: UITextField!
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var viewWithTF: UIView!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //draw() // Отрисовка интерфейса
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))) // Добавление жеста тапа на экран
    }
    
    // MARK: - Action
    @IBAction func saveButton(_ sender: Any) {
        guard let taskName = nameTaskTF.text, !taskName.isEmpty else { return } // Проверка наличия названия задачи
        
        let date = Date() // Текущая дата
        let dateFormatter = DateFormatter() // Форматтер для даты
        dateFormatter.dateFormat = "dd.MM.YYYY" // Установка формата даты
        let dateText = dateFormatter.string(from: date) // Преобразование даты в строку
        
        let task = Task(name: nameTaskTF.text!, priority: prioritySegmented.selectedSegmentIndex, performance: false, date: dateText, descript: descriptionView.text) // Создание новой задачи
        task.saveToCoreData() // Сохранение задачи в базу данных
        
        delegate?.didAddTask(task) // Вызов метода делегата для добавления задачи
        dismiss(animated: true) // Закрытие экрана добавления задачи
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true) // Закрытие экрана добавления задачи
    }
    
    @IBAction func priorityAction(_ sender: Any) {
        if prioritySegmented.selectedSegmentIndex == 0 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9774648547, green: 0.2064308822, blue: 0.1888276637, alpha: 1) } // Если выбран первый сегмент, установить красный цвет
        else if prioritySegmented.selectedSegmentIndex == 1 { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9826945662, green: 0.5444327593, blue: 0.1365438104, alpha: 1) }  // Если выбран второй сегмент, установить оранжевый цвет
        else { prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.1812253594, green: 0.7537381053, blue: 0.3327225149, alpha: 1) } // Если выбран третий сегмент, установить зеленый цвет
    }
    
    // MARK: - Method called when tapping on the screen
    @objc func tapGesture() {
        nameTaskTF.resignFirstResponder() // Скрытие клавиатуры для поля ввода названия задачи
        descriptionView.resignFirstResponder() // Скрытие клавиатуры для поля ввода описания задачи
    }
    
    // MARK: - Interface drawing method
    func draw(){
        saveOutlet.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveOutlet.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        saveOutlet.layer.shadowOpacity = 0.5
        saveOutlet.layer.shadowRadius = 10
        
        viewWithTF.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewWithTF.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        viewWithTF.layer.shadowOpacity = 0.1
        viewWithTF.layer.shadowRadius = 5
        
        descriptionView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        descriptionView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        descriptionView.layer.shadowOpacity = 0.5
        descriptionView.layer.shadowRadius = 10
    }
}
