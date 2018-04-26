//
//  UserTablesTableViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 25/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class UserTablesTableViewController: UITableViewController {

    var tables = [Datas]()
    
//    lazy var refreshControl: UIRefreshControl? = {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self,
//                                 action: #selector(UserTablesTableViewController.handleRefresh(_:)),
//                                 for: UIControlEvents.valueChanged)
//        refreshControl.tintColor = UIColor.darkText
//        return refreshControl
//    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
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
        refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
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

        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
