//
//  GroupsController.swift
//  kanban
//
//  Created by Oleksii Furman on 02/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class GroupsController: UITableViewController {
    
    var groups = [GroupDatas]()
    var email = String()
    var token = String()
    var backgroundColor = AppColor.beige
    var cellColor = AppColor.orange

    override func viewDidLoad() {
        super.viewDidLoad()
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        tableView.backgroundColor = backgroundColor
        self.navigationItem.title = "Groups"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addGroup))
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        getGroups()
    }
    
    func getGroups() {
        ApiClient.getUserGroups(email: self.email, token: self.token) { (result) in
            switch result {
            case .success(let groups):
                self.groups = groups.data
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getGroups()
        refreshControl.endRefreshing()
    }
    
    @objc func addGroup() {
        var textField = UITextField()
        let alert = UIAlertController(title: "New Groupe", message: "Write a groupe name:", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Group name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .destructive) { (alertC) in
            textField = alert.textFields![0] as UITextField
            ApiClient.createGroup(email: self.email, token: self.token, groupName: textField.text!, completion: { (result) in
                switch result {
                case .success(let newGroup):
                    self.groups.append(newGroup.data.group)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupCell", for: indexPath)
        cell.textLabel?.text = self.groups[indexPath.row].name
        cell.textLabel?.textAlignment = NSTextAlignment.center
        cell.layer.borderColor = backgroundColor.cgColor
        cell.backgroundColor = cellColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 6
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.setValue(self.groups[indexPath.row].id, forKey: "GroupId")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let groupViewController = storyboard.instantiateViewController(withIdentifier: "GroupViewController") as! GroupViewController
        self.navigationController?.pushViewController(groupViewController, animated: true)
    }
    
    //Deleting Groups
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.deleteGroup(email: self.email, token: self.token, groupId: self.groups[indexPath.row].id) { (result) in
                if result {
                    self.groups.remove(at: indexPath.row)
                    self.tableView.reloadData()
                } else {
                    print("deleting error")
                }
            }
        }
    }
}
