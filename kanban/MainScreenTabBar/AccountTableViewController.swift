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
    let backgroundColor = AppColor.beige
    let cellColor = AppColor.orange
    let textColor = AppColor.blue

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = backgroundColor
        self.navigationItem.title = "Account"
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
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellText = menuData[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountCell", for: indexPath)
        cell.layer.borderColor = backgroundColor.cgColor
        cell.backgroundColor = cellColor
        cell.layer.borderWidth = 2
        cell.textLabel?.textColor = textColor
        cell.layer.cornerRadius = 6
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
                                    UserDefaults.standard.removeObject(forKey: "Email")
                                    UserDefaults.standard.removeObject(forKey: "Token")
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginSignupVC")
                                    loginViewController.hidesBottomBarWhenPushed = true
                                    self.navigationController?.pushViewController(loginViewController, animated: true)
                                } else {
                                    let alert = UIAlertController(title: "Oups", message: "Something went wrong!", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK=(", style: .cancel, handler: nil))
                                    self.present(alert, animated: true)
                                }
            }
        }
    }
}
