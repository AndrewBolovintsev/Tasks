//
//  TaskTableViewCell.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    
    // MARK: - Variable to store the task that the cell will display
    var task: Tasks? {
        didSet {
            configureCell() // Вызов метода для настройки ячейки
        }
    }
    
    // MARK: - Outlet
    @IBOutlet weak var performanceOutlet: UIButton!
    @IBOutlet weak var nameTaskOutlet: UILabel!
    @IBOutlet weak var priorityOutlet: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Action
    @IBAction func performanceButton(_ sender: UIButton) {
        guard let task = task else { return } // Проверка наличия задачи
        task.performance = !task.performance // Изменение статуса выполнения задачи
        configureCell() // Вызов метода для настройки ячейки
        do {
            try task.managedObjectContext?.save() // Сохранение изменений в базе данных
        } catch {
            print(error)
        }
    }
    
    // MARK: - Method to set up a cell
    func configureCell() {
        guard let task = task else { return } // Проверка наличия задачи
        if task.priority == 0 { priorityOutlet.image = UIImage(named: "Image2") } // Если приоритет задачи равен 0, установить изображение с низким приоритетом
        else if task.priority == 1 { priorityOutlet.image = UIImage(named: "Image3") } // Если приоритет задачи равен 1, установить изображение с средним приоритетом
        else if task.priority == 2 { priorityOutlet.image = UIImage(named: "Image4") } // Если приоритет задачи равен 2, установить изображение с высоким приоритетом
        
        // Проверка наличия названия задачи
        if let name = task.name {
            // Если задача выполнена
            if task.performance {
                performanceOutlet.setImage(UIImage(named: "Image1"), for: .normal) // Установить изображение для кнопки выполнения задачи
                performanceOutlet.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // Цвет тени для кнопки выполнения задачи
                performanceOutlet.layer.shadowOffset = CGSize(width: 3.0, height: 3.0) // Размер тени для кнопки выполнения задачи
                performanceOutlet.layer.shadowOpacity = 0.2 // Прозрачность тени для кнопки выполнения задачи
                performanceOutlet.layer.shadowRadius = 3 // Радиус тени для кнопки выполнения задачи
                
                let attributedString = NSMutableAttributedString(string: name) // Создание атрибутированной строки с названием задачи
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length)) // Добавление атрибута зачеркивания для атрибутированной строки
                nameTaskOutlet.attributedText = attributedString // Установка атрибутированной строки в качестве текста для названия задачи
            }
            // Если задача не выполнена
            else {
                performanceOutlet.setImage(UIImage(named: "Image"), for: .normal) // Установить изображение для кнопки выполнения задачи
                nameTaskOutlet.attributedText = NSAttributedString(string: name) // Установка названия задачи в качестве текста для названия задачи
            }
        }
    }
}
