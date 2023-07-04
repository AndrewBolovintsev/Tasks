//
//  AddViewController.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit

protocol AddTaskDelegate: AnyObject {
    func didAddTask(_ task: Task)
}

class AddViewController: UIViewController {
    
    weak var delegate: AddTaskDelegate?

    @IBOutlet weak var nameTaskTF: UITextField!
    @IBOutlet weak var prioritySegmented: UISegmentedControl!
    @IBOutlet weak var saveOutlet: UIButton!
    @IBOutlet weak var viewWithTF: UIView!
    @IBOutlet weak var descriptionView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveOutlet.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        saveOutlet.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        saveOutlet.layer.shadowOpacity = 0.5
        saveOutlet.layer.shadowRadius = 10
        
        viewWithTF.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        viewWithTF.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
        viewWithTF.layer.shadowOpacity = 0.1
        viewWithTF.layer.shadowRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture))
                view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGesture() {
        nameTaskTF.resignFirstResponder()
        descriptionView.resignFirstResponder()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        guard let taskName = nameTaskTF.text, !taskName.isEmpty else { return }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        let dateText = dateFormatter.string(from: date)
        
        let task = Task(name: nameTaskTF.text!, priority: prioritySegmented.selectedSegmentIndex, performance: false, date: dateText, descript: descriptionView.text)
        task.saveToCoreData()

        let newTask = Task(name: taskName, priority: prioritySegmented.selectedSegmentIndex, performance: false, date: dateText, descript: descriptionView.text)
        delegate?.didAddTask(newTask)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func priorityAction(_ sender: Any) {
        if prioritySegmented.selectedSegmentIndex == 0 {
            prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9774648547, green: 0.2064308822, blue: 0.1888276637, alpha: 1)
        }
        else if prioritySegmented.selectedSegmentIndex == 1 {
            prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.9826945662, green: 0.5444327593, blue: 0.1365438104, alpha: 1)
        }
        else {
            prioritySegmented.selectedSegmentTintColor = #colorLiteral(red: 0.1812253594, green: 0.7537381053, blue: 0.3327225149, alpha: 1)
        }
    }
}
