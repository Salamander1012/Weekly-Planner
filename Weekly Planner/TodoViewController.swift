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
    
    
    var tasks: [String] = []
    var pickerItems = ["Today", "Tomorrow", "Monday", "Tuesday", "Wednesday", "Thursday"]
    var dynamicViewBottomConstraint: NSLayoutConstraint?
    
    var datePickerViewBottomConstraint: NSLayoutConstraint?
    var datePickerViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.contentInset = UIEdgeInsetsMake(0, -15, 0, -15);
        
        dynamicTaskField.returnKeyType = UIReturnKeyType.done
        
        
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
                print("textField has some text")
                insertNewTask()
                
            }
        }
    }
    
 
    @IBAction func dynamicAddTaskTapped(_ sender: Any) {
        addTask()
        datePickerView.selectItem(0)
    }
    
    func insertNewTask() {
        
        tasks.append(dynamicTaskField.text!)
        let indexPath = IndexPath(row: tasks.count-1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()
        dynamicTaskField.text = ""
        dynamicTaskField.endEditing(true)
        updateTaskCountLabel()
        
    }
    
    func updateTaskCountLabel() {
        if tasks.count == 0 {
            taskCountLabel.text = "Ayy you have completed all your tasks"
        } else if tasks.count == 1 {
            taskCountLabel.text = "You have \(tasks.count) task left"
        } else if tasks.count > 5 {
            print("etfff")
            taskCountLabel.text = "You have \(tasks.count) tasks left, better get to work"
        } else if tasks.count > 1 {
            print("asdadsasd")
            taskCountLabel.text = "You have \(tasks.count) incomplete tasks"
        }
    }
    
}

extension TodoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let task = tasks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell") as! TaskCell
        cell.setUpTaskCell(title: task)
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        return cell
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
            tasks.remove(at: indexPath.row)
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            updateTaskCountLabel()
        }
    }
}

extension TodoViewController: AKPickerViewDelegate, AKPickerViewDataSource {
    
    func numberOfItemsInPickerView(_ pickerView: AKPickerView) -> Int {
        return pickerItems.count
    }
    
    func pickerView(_ pickerView: AKPickerView, titleForItem item: Int) -> String {
        return pickerItems[item]
    }
    
    func pickerView(_ pickerView: AKPickerView, didSelectItem item: Int) {
        print("Selected item: \(datePickerView.selectedItem)")
        
        
        
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
