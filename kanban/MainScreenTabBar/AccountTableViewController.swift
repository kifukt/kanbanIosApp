//
//  AccountTableViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 11/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    let menuData = [["Log Out"],["Help","Information","Delete account"]]
    let headerTitles = ["Account", "Help"]

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 3)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return menuData.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellText = menuData[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        cell.textLabel?.text = cellText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < headerTitles.count {
            return headerTitles[section]
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath)
        if currentCell?.textLabel?.text == "Log Out" {
            ApiClient.signOut(email: UserDefaults.standard.value(forKey: "Email") as! String,
                              token: UserDefaults.standard.value(forKey: "Token") as! String) { (result) in
                                if result {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
                                    self.navigationController?.pushViewController(loginViewController, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "Oups", message: "Something went wrong!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK=(", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                }
            }
            
        }
        
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
