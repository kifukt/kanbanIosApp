//
//  UserTablesTableViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 25/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class UserTablesTableViewController: UITableViewController {
    
    var tables = [[TableDatas](),[TableDatas]()]
    var sectionTitles = ["Private", "Public"]
    var backgroundColor = AppColor.beige
    var cellColor = AppColor.orange
    var email = String()
    var token = String()
    
    
    private func getTables() {
        ApiClient.getUserTables(email: email, token: token) { (result) in
            switch result {
            case .success(let tablesObject):
                self.tables[0].removeAll()
                self.tables[1].removeAll()
                for table in tablesObject.data {
                    if table.is_private {
                        self.tables[0].append(table)
                    } else {
                        self.tables[1].append(table)
                    }
                }
                print(self.tables)
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = backgroundColor
        self.tabBarController?.tabBar.isHidden = false
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self, action: #selector(addTable))
        self.tableView.separatorStyle = .none
        self.navigationItem.title = "Tables"
        tableView.backgroundColor = backgroundColor
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        
        getTables()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        getTables()
        refreshControl.endRefreshing()
    }
    
    @objc func addTable() {
        var firstTextField = UITextField()
        var isPrivate = Bool()
        let chooseGroupAletr = UIAlertController(title: "Choose group", message: nil, preferredStyle: .actionSheet)
        func sendRequest() {
            ApiClient.getUserGroups(email: self.email, token: self.token) { (result) in
                switch result {
                case .success(let groups):
                    for group in groups.data {
                        let action = UIAlertAction(title: group.name, style: .default, handler: { (alertC) in
                            ApiClient.createUserTable(email: self.email, token: self.token, name: firstTextField.text!, groupId: group.id, completion: { (result) in
                                switch result {
                                case .success(_):
                                    self.getTables()
                                case .failure(let error):
                                    print(error.localizedDescription)
                                }
                            })
                        })
                        chooseGroupAletr.addAction(action)
                    }
                    self.present(chooseGroupAletr, animated: true)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        let isPrivateAskAlert = UIAlertController(title: "Is Private?", message: "Do you want to make private table?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alertC) -> Void in
            isPrivate = true
            ApiClient.createUserTable(email: self.email, token: self.token, name: firstTextField.text!, groupId: nil, completion: { (result) in
                switch result {
                case .success(_):
                    self.getTables()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        })
        let noAction = UIAlertAction(title: "No", style: UIAlertActionStyle.destructive, handler: { (alertC) -> Void in
            isPrivate = false
            sendRequest()
        })
        
        let alert = UIAlertController(title: "Add Table", message: "Table name:", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Table name"
        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alertC -> Void in
            firstTextField = alert.textFields![0] as UITextField
            self.present(isPrivateAskAlert, animated: true)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        chooseGroupAletr.addAction(cancelAction)
        isPrivateAskAlert.addAction(yesAction)
        isPrivateAskAlert.addAction(noAction)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tables.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.sectionTitles.count {
            return sectionTitles[section]
        } else { return nil }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(tables[section].count)
        return tables[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = tables[indexPath.section][indexPath.row].name
        cell.layer.borderColor = backgroundColor.cgColor
        cell.backgroundColor = cellColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 6
        cell.clipsToBounds = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableId = tables[indexPath.section][indexPath.row].id
        UserDefaults.standard.setValue(tableId, forKey: "TableId")
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let listCollectionViewController = storyboard.instantiateViewController(withIdentifier: "ListsController") as! ListsController
        self.navigationController?.pushViewController(listCollectionViewController, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.deleteTable(email: UserDefaults.standard.value(forKey: "Email") as! String,
                                  token: UserDefaults.standard.value(forKey: "Token") as! String,
                                  tableId: tables[indexPath.section][indexPath.row].id) { (result) in
                                    if result {
                                        self.tables[indexPath.section].remove(at: indexPath.row)
                                        self.getTables()
                                        tableView.reloadData()
                                    } else {
                                        print("ERROR")
                                    }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("KEK")
    }
    
}
