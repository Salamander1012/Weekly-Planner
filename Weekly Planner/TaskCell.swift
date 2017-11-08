//
//  TaskCell.swift
//  Swift Simple Todo
//
//  Created by Salman Fakhri on 11/2/17.
//  Copyright © 2017 Salman Fakhri. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var taskTitleLabel: UILabel!
    
    func setUpTaskCell(title: String) {
        taskTitleLabel.text = title
    }

}
