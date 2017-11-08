//
//  TodoViewController.swift
//  Swift Simple Todo
//
//  Created by Salman Fakhri on 11/2/17.
//  Copyright © 2017 Salman Fakhri. All rights reserved.
//

import UIKit



class TodoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var taskCountLabel: UILabel!
    @IBOutlet weak var dynamicInputView: UIView!
    @IBOutlet weak var dynamicTaskField: UITextField!
    @IBOutlet weak var datePickerView: AKPickerView!
    @IBOutlet weak var createTaskButton: UIButton!
    
    
    var pickerItems = ["Today", "Tomorrow", "Monday", "Tuesday"]
    
    var dynamicViewBottomConstraint: NSLayoutConstraint?
    
    struct TaskSections {
        var sectionName: String!
        var tasks: [String] = []
    }
    var sectionsArray = [TaskSections]()
    
    var datePickerViewBottomConstraint: NSLayoutConstraint?
    var datePickerViewHeightConstraint: NSLayoutConstraint?
    
    let hapticResponse = UISelectionFeedbackGenerator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sectionsArray = [
            TaskSections(sectionName: "Today", tasks: []),
            TaskSections(sectionName: "Tomorrow", tasks: []),
            TaskSections(sectionName: "Monday", tasks: []),
            TaskSections(sectionName: "Tuesday", tasks: []),
            TaskSections(sectionName: "Wednesday", tasks: []),
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, -15);
        
        dynamicTaskField.returnKeyType = UIReturnKeyType.done
        
        createTaskButton.setTitle("", for: .normal)
        
        datePickerView.delegate = self
        datePickerView.dataSource = self
        datePickerView.font = UIFont(name: "Avenir Next", size: 17)!
        datePickerView.textColor = UIColor.white
        datePickerView.highlightedFont = UIFont(name: "Avenir Next Demi Bold", size: 17)!
        datePickerView.highlightedTextColor = UIColor.black
        datePickerView.interitemSpacing = 5
        datePickerView.selectItem(0)
        datePickerView.reloadData()
        
        updateTaskCountLabel()
        
        
        
        dynamicViewBottomConstraint = NSLayoutConstraint(item: dynamicInputView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        datePickerViewBottomConstraint = NSLayoutConstraint(item: datePickerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 40)
        datePickerViewHeightConstraint = NSLayoutConstraint(item: datePickerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)


   
        
        view.addConstraint(dynamicViewBottomConstraint!)
        view.addConstraint(datePickerViewBottomConstraint!)
        view.addConstraint(datePickerViewHeightConstraint!)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            //print(keyboardFrame)
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            dynamicViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height - 30: 0
            datePickerViewBottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height: 40
            
            createTaskButton.setTitle("Add", for: .normal)
            if isKeyboardShowing {
                createTaskButton.setTitle("Add", for: .normal)
            } else {
                createTaskButton.setTitle("", for: .normal)
            }
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }, completion: {(completed) in })
        }
        
    }
    
   
    
   
    
    fileprivate func addTask() {
        if dynamicTaskField.text?.isEmpty ?? true {
            print("taskField is empty")
        } else {
            if !(dynamicTaskField.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
                
                let currentSection  = datePickerView.selectedItem
                sectionsArray[currentSection].tasks.append(dynamicTaskField.text!)
                let indexPath = IndexPath(row: sectionsArray[currentSection].tasks.count-1, section: currentSection)
                tableView.beginUpdates()
                tableView.insertRows(at: [indexPath], with: .automatic)
                tableView.endUpdates()
                dynamicTaskField.text = ""
                dynamicTaskField.endEditing(true)
                updateTaskCountLabel()
                
            }
        }
    }
    
 
    @IBAction func dynamicAddTaskTapped(_ sender: Any) {
        addTask()
        datePickerView.selectItem(0)
    }
    
   
    
    func updateTaskCountLabel() {
        if sectionsArray[0].tasks.count == 0 {
            taskCountLabel.text = "Ayy you have completed all your tasks"
        } else if sectionsArray[0].tasks.count == 1 {
            taskCountLabel.text = "You have \(sectionsArray[0].tasks.count) task left"
        } else if sectionsArray[0].tasks.count > 5 {
            taskCountLabel.text = "You have \(sectionsArray[0].tasks.count) tasks left, better get to work"
        } else if sectionsArray[0].tasks.count > 1 {
            taskCountLabel.text = "You have \(sectionsArray[0].tasks.count) incomplete tasks"
        }
    }
    
}

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionsArray[section].tasks.count
//        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = sectionsArray[indexPath.section].tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.setUpTaskCell(title: task)
//        let task = tasks[indexPath.row]
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
//        cell.setUpTaskCell(title: task)
//        cell.separatorInset = UIEdgeInsets.zero
//        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].sectionName
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if(tableView.isEqual(scrollView)) {
            datePickerView.selectItem(0)
            dynamicTaskField.endEditing(true)
            dynamicTaskField.text = ""
        }
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        dynamicTaskField.text = ""
        dynamicTaskField.endEditing(true)
        datePickerView.selectItem(0)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
//            tasks.remove(at: indexPath.row)
            sectionsArray[indexPath.section].tasks.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            updateTaskCountLabel()
        }
    }
}

extension TodoViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return sectionsArray.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return sectionsArray[item].sectionName
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        print("Selected item: \(datePickerView.selectedItem)")
        
        
        hapticResponse.selectionChanged()
    }
    
    
}

extension UIFont {
    
    func withTraits(traits:UIFontDescriptorSymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
}
