//
//  GroupViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 02/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var email = String()
    var token = String()
    var groupId = Int()
    var group: UserDataGroup?
    
    @IBOutlet weak var leaderName: UILabel!
    
    @IBOutlet weak var usersLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addUserButton: UIButton!
    @IBAction func addUserToGroup(_ sender: UIButton) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add user", message: "Type a user's e-mail", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .destructive) { (alertC) in
            textField = alert.textFields![0] as UITextField
            ApiClient.addUserToGroup(email: self.email, token: self.token, groupId: self.groupId, userEmail: textField.text!, completion: { (result) in
                switch result {
                case .success(let user):
                    self.group = user.data.group
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "User e-mail"
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }
    
    
    
    private func getGroupInfo() {
        ApiClient.showGroup(email: self.email, token: self.token, groupId: self.groupId) { (result) in
            switch result {
            case .success(let group):
                self.group = group.data.group
                self.addUserButton.setTitle("Add User", for: UIControlState.normal)
                self.navigationItem.title = self.group?.name
                self.leaderName.text = "Leader: " + (self.group?.leader?.email)!
                self.usersLabel.text = "Users:"
                self.usersLabel.textAlignment = NSTextAlignment.center
                self.leaderName.textAlignment = NSTextAlignment.center
                self.view.reloadInputViews()
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        groupId = UserDefaults.standard.value(forKey: "GroupId") as! Int
        self.getGroupInfo()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = self.group?.members.count {
            return rows
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupUser", for: indexPath)
        
        cell.textLabel?.text = self.group?.members[indexPath.row].email
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Set Leader?", message: "Set this user as Leader?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "YES", style: .destructive) { (alertC) in
            ApiClient.changeLeader(email: self.email, token: self.token, groupId: self.groupId, leaderId: (self.group?.members[indexPath.row].id)!, completion: { (result) in
                switch result {
                case .success(_):
                    self.getGroupInfo()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        present(alert, animated: true)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.removeUserFromGroup(email: self.email, token: self.token, groupId: self.groupId, userId: (self.group?.members[indexPath.row].id)!) { (result) in
                switch result {
                case .success(_):
                    self.group?.members.remove(at: indexPath.row)
                    DispatchQueue.main.async {
                        tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
