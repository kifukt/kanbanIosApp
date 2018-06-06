//
//  TableDetailController.swift
//  kanban
//
//  Created by Oleksii Furman on 06/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class TableDetailController: UIViewController {
    
    var table: TableDatas!
    var email = String()
    var token = String()
    var tableId = Int()
    var backgroundColor = AppColor.beige
    var textColor = AppColor.blue

    @IBOutlet weak var tableNameLabel: UILabel!
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var editButton: UIButton!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Edit table", message: nil, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addTextField { (textfireld: UITextField) in
            textfireld.placeholder = "Table name"
        }
        let saveAction = UIAlertAction(title: "Edit", style: .default) { (alertC) in
            let textfield = alert.textFields![0] as UITextField
            ApiClient.updateTable(email: self.email, token: self.token, name: textfield.text!, tableId: self.tableId, completion: { (result) in
                switch result {
                case .success(_):
                    self.getTable()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
        
    }
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you shure?", message: nil, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Yes", style: .destructive) { (alertC) in
            ApiClient.deleteTable(email: self.email, token: self.token, tableId: self.tableId) { (result) in
                if result {
                    DispatchQueue.main.async {
                        let userTablesVC = self.storyboard?.instantiateViewController(withIdentifier: "UserTablesVC") as! UserTablesTableViewController
                        self.navigationController?.pushViewController(userTablesVC, animated: true)
                    }
                } else {
                    print("Error while deleting table")
                }
            }
        }
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func getTable() {
        ApiClient.showTable(email: self.email, token: self.token, tableId: self.tableId) { (result) in
            switch result {
            case .success(let table):
                self.table = table.data.table
                self.tableNameLabel.text = table.data.table.name
                if let groupId = table.data.table.group_id {
                    ApiClient.showGroup(email: self.email, token: self.token, groupId: groupId, completion: { (result) in
                        switch result {
                        case .success(let group):
                            self.groupNameLabel.text = group.data.group.name
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    })
                } else {
                    self.groupNameLabel.text = "Private"
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
        getTable()
        
        self.view.backgroundColor = backgroundColor
        
        tableNameLabel.textAlignment = .center
        tableNameLabel.font = tableNameLabel.font.withSize(40)
        tableNameLabel.textColor = textColor
        
        groupNameLabel.textAlignment = .center
        groupNameLabel.font = groupNameLabel.font.withSize(20)
        groupNameLabel.textColor = textColor
        
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(textColor, for: .normal)
        editButton.backgroundColor = AppColor.orange
        editButton.layer.cornerRadius = 6
        
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.setTitleColor(textColor, for: .normal)
        deleteButton.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        deleteButton.layer.cornerRadius = 6
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
