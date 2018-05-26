//
//  ListCollectionViewController.swift
//  kanban
//
//  Created by Oleksii Furman on 16/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit



class ListCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let reuseIdentifier = "List"
    
    var lists = [ListDatas]()
    var email = String()
    var token = String()
    var tableId = Int()
//    var stackView: UIStackView
    
    private func getCards() {
        for index in 0...self.lists.count - 1 {
            ApiClient.getCards(email: self.email, token: self.token, tableId: self.tableId, listId: self.lists[index].id) { (result) in
                switch result {
                case .success(let card):
                    self.lists[index].cards = card.data
                    if index == self.lists.count - 1 {
                        self.collectionView!.reloadData()
                        self.collectionView!.collectionViewLayout.invalidateLayout()
                        self.collectionView!.layoutSubviews()
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
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    @objc func addList() {
        var listNameField = UITextField()
        
        func createList() {
            ApiClient.createList(email: email, token: token, tableId: tableId, name: listNameField.text!) { (result) in
                switch result {
                case .success(_):
                    self.collectionView!.reloadData()
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
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.lists.count
    }
    
    private func titleButton(withTitle title: String) -> UIButton {
        let newButton = UIButton(type: .system)
        newButton.backgroundColor = UIColor.gray
        newButton.setTitle(title, for: .normal)
        newButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        return newButton
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = UIColor.blue.withAlphaComponent(0.5)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.width, height: 30))
        title.text = self.lists[indexPath.row].name
        title.textAlignment = .center
        
        
        
        let stackView = UIStackView(arrangedSubviews: [title])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        
        if let cardsInList = self.lists[indexPath.row].cards {
            for card in cardsInList {
                stackView.addArrangedSubview(self.titleButton(withTitle: card.title))
            }
        }
        stackView.addArrangedSubview(self.titleButton(withTitle: "Add new card"))
        cell.addSubview(stackView)
        let viewsDictionary = ["stackView":stackView]
        let stackView_H = NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackView]-10-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: viewsDictionary)
        let stackView_V = NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[stackView]-10-|", options: NSLayoutFormatOptions(rawValue:0), metrics: nil, views: viewsDictionary)
        cell.addConstraints(stackView_H)
        cell.addConstraints(stackView_V)
        
        return cell
    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
        let cell = sender?.superview
        let indexPath = self.collectionView?.indexPath(for: cell)
        switch sender?.title {
        case "Add new button":
            cell
            stackView.addArrangedSubview(self.titleButton(withTitle: "ALALALALONG"))
        default:
            print("KEK")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let cardsAmount = self.lists[indexPath.row].cards?.count {
            return CGSize(width: view.bounds.width, height: CGFloat((2 + cardsAmount) * 50))
        }
        return CGSize(width: view.bounds.width, height: 100)
    }
    
    
    
}
