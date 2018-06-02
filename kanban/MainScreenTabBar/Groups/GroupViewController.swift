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
    
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var leaderName: UILabel!
    
    @IBOutlet weak var changeLeaderButton: UIButton!
    @IBAction func changeLeader(_ sender: UIButton) {
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addUserButton: UIButton!
    @IBAction func addUserToGroup(_ sender: UIButton) {
    }
    
    
    
    func getGroupInfo() {
        ApiClient.showGroup(email: self.email, token: self.token, groupId: self.groupId) { (result) in
            switch result {
            case .success(let group):
                self.group = group.data.group
                print(group)
                self.groupName.text = self.group?.name
                self.groupName.textAlignment = NSTextAlignment.center
                self.leaderName.text = self.group?.leader?.email
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
        getGroupInfo()

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

}
