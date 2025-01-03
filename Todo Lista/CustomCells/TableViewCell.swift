//
//  TableViewCell.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 21.9.2024.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    var taskID: Int32?
    var delegate: ReloadDelegate?

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var completedButton: UIButton!
    
    @IBAction func completedButtonPressed(_ sender: UIButton) {
        guard let id = taskID else { return }
        guard let taskToMark = CoreDataStack.shared.fetchTaskByID(taskID: id) else { return }
        
        let compeleted = !taskToMark.isCompleted
        
        CoreDataStack.shared.markTaskCompleted(id: id, completed: compeleted)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
