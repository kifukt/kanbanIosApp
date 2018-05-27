//
//  ListsController.swift
//  kanban
//
//  Created by Oleksii Furman on 26/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class ListsController: UITableViewController {
    
    var lists = [ListDatas]()
    var email = String()
    var token = String()
    var tableId = Int()
    
    private func getCards() {
        for index in 0...self.lists.count - 1 {
            ApiClient.getCards(email: self.email, token: self.token, tableId: self.tableId, listId: self.lists[index].id) { (result) in
                switch result {
                case .success(let card):
                    self.lists[index].cards = card.data
                    if index == self.lists.count - 1 {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func getLists() {
        ApiClient.getLists(email: self.email, token: self.token, tableId: tableId) { (result) in
            switch result {
            case .success(let list):
                self.lists = list.data
                self.getCards()
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
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
        self.getLists()
    }

    @objc func addList() {
        var listNameField = UITextField()
        
        func createList() {
            ApiClient.createList(email: email, token: token, tableId: tableId, name: listNameField.text!) { (result) in
                switch result {
                case .success(_):
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        let alert = UIAlertController(title: "Name:", message: "Write a name of the list.", preferredStyle: .alert)
        
        alert.addTextField {  (textField: UITextField) in
            textField.placeholder = "List name"
        }
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (alertC) -> Void in
            listNameField = alert.textFields![0] as UITextField
            createList()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.lists.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < self.lists.count {
            return self.lists[section].name
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.lists[section].cards!.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        if indexPath.row < self.lists[indexPath.section].cards!.count {
            let cellTitle = self.lists[indexPath.section].cards?[indexPath.row].title
            cell.textLabel?.text = cellTitle
        } else {
            cell.textLabel?.text = "Add Card"
        }

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
