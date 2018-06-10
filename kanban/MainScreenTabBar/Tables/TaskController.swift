//
//  TaskController.swift
//  kanban
//
//  Created by Oleksii Furman on 09/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class TaskController: UITableViewController {

    let backgroundColor = AppColor.beige
    let textColor = AppColor.blue
    let cellColor = AppColor.orange
    
    var email: String!
    var token: String!
    var tableId: Int!
    var listId: Int!
    var cardId: Int!
    var taskListId: Int!
    
    var sections = ["ToDo", "Done"]
    var tasks = [[TaskDatas](), [TaskDatas]()]
    
    private func getTasks() {
        ApiClient.getTasks(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId, taskListId: self.taskListId) { (result) in
            switch result {
            case .success(let tasks):
                self.tasks[0].removeAll()
                self.tasks[1].removeAll()
                for task in tasks.data {
                    if task.is_finished {
                        self.tasks[1].append(task)
                    } else {
                        self.tasks[0].append(task)
                    }
                }
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
        taskListId = UserDefaults.standard.value(forKey: "TaskListId") as! Int
        
        getTasks()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        
        tableView.backgroundColor = backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addTask() {
        var taskListName = UITextField()
        let alert = UIAlertController(title: "Add Task", message: "Write task name:", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Task name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alertC) in
            taskListName = alert.textFields![0] as UITextField
            ApiClient.createTask(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId,
                                 cardId: self.cardId, taskListId: self.taskListId, name: taskListName.text!, completion: { (result) in
                switch result {
                case .success(_):
//                    self.tasks[0].append(newTask.data.task)
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                    }
                    self.getTasks()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.sections.count {
            return sections[section]
        } else { return nil }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks[section].count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Task", for: indexPath)

        cell.textLabel?.textColor = textColor
        cell.layer.borderColor = backgroundColor.cgColor
        cell.backgroundColor = cellColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        
        cell.textLabel?.text = self.tasks[indexPath.section][indexPath.row].content        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.tasks[indexPath.section][indexPath.row].is_finished {
            ApiClient.updateTask(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId,
                                 taskListId: self.taskListId, taskId: self.tasks[indexPath.section][indexPath.row].id,
                                 name: self.tasks[indexPath.section][indexPath.row].content, isFinished: false,
                                 assignedToUser: self.tasks[indexPath.section][indexPath.row].assigned_to.id!) { (result) in
                                    switch result {
                                    case .success(let task):
                                        self.tasks[1].remove(at: indexPath.row)
                                        self.tasks[0].append(task.data.task)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
            }
        } else {
            ApiClient.updateTask(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId,
                                 taskListId: self.taskListId, taskId: self.tasks[indexPath.section][indexPath.row].id,
                                 name: self.tasks[indexPath.section][indexPath.row].content, isFinished: true,
                                 assignedToUser: self.tasks[indexPath.section][indexPath.row].assigned_to.id!) { (result) in
                                    switch result {
                                    case .success(let task):
                                        self.tasks[0].remove(at: indexPath.row)
                                        self.tasks[1].append(task.data.task)
                                        DispatchQueue.main.async {
                                            self.tableView.reloadData()
                                        }
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
            }
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.deleteTask(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId, taskListId: taskListId, taskId: tasks[indexPath.section][indexPath.row].id) { (result) in
                if result {
                    self.tasks[indexPath.section].remove(at: indexPath.row)
                    self.tableView.reloadData()
                } else {
                    print("Delete Error!")
                }
            }
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
