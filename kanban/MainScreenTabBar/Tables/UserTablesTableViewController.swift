//
//  UserTablesTableViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 25/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class UserTablesTableViewController: UITableViewController {
    
    var tables = [TableDatas]()
    
    private func getTables() {
        ApiClient.getUserTables(email: UserDefaults.standard.value(forKey: "Email") as! String,
                                token: UserDefaults.standard.value(forKey: "Token") as! String) { (result) in
                                    switch result {
                                    case .success(let tablesObject):
                                        self.tables = tablesObject.data
                                        self.tableView.reloadData()
                                    case .failure(let error):
                                        print(error.localizedDescription)
                                    }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self, action: #selector(addTable))
        self.navigationItem.title = "Tables"
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
        
        func sendRequest() {
            ApiClient.createUserTable(email: UserDefaults.standard.value(forKey: "Email") as! String,
                                      token: UserDefaults.standard.value(forKey: "Token") as! String,
                                      name: firstTextField.text!, isPrivate: isPrivate,
                                      completion: { (result) in
                                        switch result {
                                        case .success(_):
                                            self.getTables()
                                            self.tableView.reloadData()
                                        case .failure(let error):
                                            print(error.localizedDescription)
                                        }
            })
        }
        
        let isPrivateAskAlert = UIAlertController(title: "Is Private?", message: "Do you want to make private table?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { (alertC) -> Void in
            isPrivate = true
            sendRequest()
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
        
        isPrivateAskAlert.addAction(yesAction)
        isPrivateAskAlert.addAction(noAction)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source
    //
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return tables.count
    //    }
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tables.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let table = tables[indexPath.row]
        cell.textLabel?.text = table.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableId = tables[indexPath.row].id
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
                                  tableId: tables[indexPath.row].id) { (result) in
                                    if result {
                                        self.tables.remove(at: indexPath.row)
                                        self.getTables()
                                        tableView.reloadData()
                                    } else {
                                        print("ERROR")
                                    }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.green.withAlphaComponent(CGFloat(self.tables.count == 0 ? 0 : (0.6 / Double(self.tables.count)) * Double(indexPath.row + 1)))
        
    }
    
}
