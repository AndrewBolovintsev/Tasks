//
//  TaskTableViewCell.swift
//  Tasks
//
//  Created by Andrew on 25.06.23.
//

import UIKit
import CoreData

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var performanceOutlet: UIButton!
    @IBOutlet weak var nameTaskOutlet: UILabel!
    @IBOutlet weak var priorityOutlet: UIImageView!
    
    var task: Tasks? {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell() {
        guard let task = task else { return }
        if task.priority == 0 {
            priorityOutlet.image = UIImage(named: "Image2")
        } else if task.priority == 1 {
            priorityOutlet.image = UIImage(named: "Image3")
        } else if task.priority == 2 {
            priorityOutlet.image = UIImage(named: "Image4")
        }
        if let name = task.name {
            if task.performance {
                performanceOutlet.setImage(UIImage(named: "Image1"), for: .normal)
                performanceOutlet.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
                performanceOutlet.layer.shadowOffset = CGSize(width: 3.0, height: 3.0)
                performanceOutlet.layer.shadowOpacity = 0.2
                performanceOutlet.layer.shadowRadius = 3
                
                let attributedString = NSMutableAttributedString(string: name)
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, attributedString.length))
                nameTaskOutlet.attributedText = attributedString
            } else {
                performanceOutlet.setImage(UIImage(named: "Image"), for: .normal)
                nameTaskOutlet.attributedText = NSAttributedString(string: name)
            }
        }
    }
    
    @IBAction func performanceButton(_ sender: UIButton) {
        guard let task = task else { return }
        task.performance = !task.performance
        configureCell()
        do {
            try task.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }
}
