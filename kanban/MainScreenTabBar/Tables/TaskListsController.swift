//
//  TaskListsController.swift
//  kanban
//
//  Created by Oleksii Furman on 09/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class TaskListsController: UITableViewController {

    let backgroundColor = AppColor.beige
    let textColor = AppColor.blue
    let cellColor = AppColor.orange
    
    var email: String!
    var token: String!
    var tableId: Int!
    var listId: Int!
    var cardId: Int!
    
    var taskLists = [TaskListDatas]()
    
    private func getTaskLists() {
        ApiClient.getTaskLists(email: email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId) { (result) in
            switch result {
            case .success(let taskLists):
                self.taskLists = taskLists.data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        tableId = UserDefaults.standard.value(forKey: "TableId") as! Int
        listId = UserDefaults.standard.value(forKey: "ListId") as! Int
        cardId = UserDefaults.standard.value(forKey: "CardId") as! Int

        self.getTaskLists()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTaskList))
        
        tableView.backgroundColor = backgroundColor
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTaskList() {
        var taskListName = UITextField()
        let alert = UIAlertController(title: "Add task list", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "List name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertC) in
            taskListName = alert.textFields![0] as UITextField
            ApiClient.createTaskList(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId, name: taskListName.text!, completion: { (result) in
                switch result {
                case .success(let newtaskList):
                    self.taskLists.append(newtaskList.data.task_list)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskList", for: indexPath)
        cell.textLabel?.text = taskLists[indexPath.row].name
        cell.textLabel?.textColor = textColor
        cell.layer.borderColor = backgroundColor.cgColor
        cell.backgroundColor = cellColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(self.taskLists[indexPath.row].id, forKey: "TaskListId")
        let taskController = self.storyboard?.instantiateViewController(withIdentifier: "TaskController") as! TaskController
        self.navigationController?.pushViewController(taskController, animated: true)
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.deleteTaskList(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId, taskListId: self.taskLists[indexPath.row].id) { (result) in
                if result {
                    self.getTaskLists()
                } else {
                    print("Error while downloading!")
                }
            }
        }
    }
}
