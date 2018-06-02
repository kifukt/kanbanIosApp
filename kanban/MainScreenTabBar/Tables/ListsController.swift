//
//  ListsController.swift
//  kanban
//
//  Created by Oleksii Furman on 27/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit
import AlamofireNetworkActivityIndicator

private let reuseIdentifier = "List"

class ListsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, OptionButtonsDelegate {
    
    var lists = [ListDatas]()
    var email = String()
    var token = String()
    var tableId = Int()
    var storedOffsets = [Int: CGFloat]()
    var alert: UIViewController!
    
    private func getCards() {
        if self.lists.count >= 1 {
            for index in 0...self.lists.count - 1 {
                ApiClient.getCards(email: self.email, token: self.token, tableId: self.tableId, listId: self.lists[index].id) { (result) in
                    switch result {
                    case .success(let card):
                        self.lists[index].cards = card.data
                        if self.lists[index].cards != nil {
                            self.lists[index].cards?.append(CardData(id: nil, title: "Add Card ➕", description: nil))
                        } else {
                            self.lists[index].cards = [CardData(id: nil, title: "Add Card ➕", description: nil)]
                        }
                        
                        if index == self.lists.count - 1 {
                            self.dismiss(animated: false, completion: nil)
                            self.collectionView!.reloadData()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
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
        self.navigationItem.title = "Lists"
        UserDefaults.standard.removeObject(forKey: "CardId")
        UserDefaults.standard.removeObject(forKey: "ListId")
        
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
                case .success(let list):
                    self.lists.append(ListDatas(id: list.data.list.id, name: list.data.list.name, cards: []))
                    DispatchQueue.main.async {
                        self.collectionView!.reloadData()
                    }
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

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.lists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ListCell
        cell.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(0.3))
        cell.listName.text = self.lists[indexPath.row].name
        cell.listName.frame = CGRect(x: 0, y: 0, width: cell.bounds.width, height: CGFloat(44))
        cell.tableView.isScrollEnabled = false
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    func deleteTapped(at index: IndexPath) {
        let alert = UIAlertController(title: "Delete list?", message: nil, preferredStyle: .actionSheet)
        let listId = lists[index.row].id
        let acceptAction = UIAlertAction(title: "Yes", style: .destructive) { (alertC) in
            ApiClient.deleteList(email: self.email, token: self.token, tableId: self.tableId, listId: listId, completion: { (result) in
                if result {
                    self.lists.remove(at: index.row)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                        
                    }
                } else {
                    print("ERROR")
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(acceptAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: CGFloat((1 + (self.lists[indexPath.row].cards?.count ?? 0)) * 44 ))
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let collectionViewCell = cell as? ListCell else { return }
        collectionViewCell.setTableViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
        collectionViewCell.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let collectionViewCell = cell as? ListCell else { return }
        storedOffsets[indexPath.row] = collectionViewCell.collectionViewOffset
    }
}

    extension ListsController: UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.lists[tableView.tag].cards?.count ?? 1
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Card", for: indexPath)
            cell.textLabel?.textAlignment = NSTextAlignment.center
            if let cardTitle = self.lists[tableView.tag].cards {
                if cardTitle.count > 0 {
                    cell.textLabel?.text = cardTitle[indexPath.row].title
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            var cardTitleTextField = UITextField()
            if tableView.numberOfRows(inSection: 0) - 1 == indexPath.row {
                let alert = UIAlertController(title: "New Card", message: "Write a card title:", preferredStyle: .alert)
                alert.addTextField { (textField: UITextField) in
                    textField.placeholder = "New Card"
                }
                let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: { alertC -> Void in
                    cardTitleTextField = alert.textFields![0] as UITextField
                    ApiClient.createCard(email: self.email, token: self.token,
                                         tableId: self.tableId, listId: self.lists[tableView.tag].id,
                                         title: cardTitleTextField.text!, description: "") { (result) in
                        switch result {
                        case .success(let card):
                            let addCell = self.lists[tableView.tag].cards?.popLast()
                            
                            let cardObject = CardData(id: card.data.card.id, title: card.data.card.title, description: card.data.card.description)
                            self.lists[tableView.tag].cards?.append(cardObject)
                            self.lists[tableView.tag].cards?.append(addCell!)
                            DispatchQueue.main.async {
                                self.collectionView?.reloadData()
                                tableView.reloadData()
                            }
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    }
                })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                alert.addAction(saveAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            } else {
                UserDefaults.standard.setValue(self.lists[tableView.tag].cards![indexPath.row].id, forKey: "CardId")
                UserDefaults.standard.setValue(self.lists[tableView.tag].id, forKey: "ListId")
                let cardController = self.storyboard?.instantiateViewController(withIdentifier: "CardController") as! CardController
                self.navigationController?.pushViewController(cardController, animated: true)
            }
        }
        
    }
    
    
    
