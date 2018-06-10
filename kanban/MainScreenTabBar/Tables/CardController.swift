//
//  CardController.swift
//  kanban
//
//  Created by Oleksii Furman on 28/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class CardController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardName: UILabel!
    @IBOutlet weak var taskListsButtonLabel: UIButton!
    @IBOutlet weak var cardDescription: UITextView!
    
    let backgroundColor = AppColor.beige
    let buttonColor = AppColor.orange
    let textColor = AppColor.blue
    
    @IBOutlet weak var editButtonLabel: UIButton!
    @IBAction func editButton(_ sender: UIButton) {
        ApiClient.updateCard(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId, title: self.card.title, description: self.cardDescription.text) { (result) in
            switch result {
            case .success(let card):
                self.card.description = card.data.card.description
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    @IBOutlet weak var deleteButtonLabel: UIButton!
    @IBAction func deleteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you shure?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: .default) { (alertC) in
            ApiClient.deleteCard(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.card.id!) { (result) in
                if result {
                    DispatchQueue.main.async {
                        let listsController = self.storyboard?.instantiateViewController(withIdentifier: "ListsController") as! ListsController
                        self.navigationController?.pushViewController(listsController, animated: true)
                    }
                } else {
                    let alert = UIAlertController(title: "OUPS!", message: "Something goes wrong =(", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func taskListsButtonTapped(_ sender: UIButton) {
        let taskListsController = self.storyboard?.instantiateViewController(withIdentifier: "TaskListsController") as! TaskListsController
        self.navigationController?.pushViewController(taskListsController, animated: true)
    }
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func sendCommentTapped(_ sender: UIButton) {
        if let comment = commentTextField.text {
            ApiClient.createComment(email: self.email, token: self.token, tableId: tableId, listId: listId, cardId: cardId, comment: comment) { (result) in
                switch result {
                case .success(let newComment):
                    self.comments.append(newComment.data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    var card: CardData!
    var comments = [CommentData]()
    var email: String!
    var token: String!
    var tableId: Int!
    var listId: Int!
    var cardId: Int!
    
    func getComments() {
        ApiClient.getComments(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId) { (result) in
            switch result {
            case .success(let comments):
                self.comments = comments.data
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Card"
        
        commentTextField.delegate = self
        commentTextField.textColor = textColor
        commentTextField.addTarget(self, action: #selector(CardController.textFieldReturned), for: UIControlEvents.editingDidEndOnExit)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = backgroundColor
        
        self.view.backgroundColor = backgroundColor
        
        cardName.font = cardName.font.withSize(50)
        cardName.layer.cornerRadius = 6
        cardName.backgroundColor = AppColor.yellow
        cardName.textColor = textColor
        
        editButtonLabel.setTitleColor(textColor, for: .normal)
        editButtonLabel.titleLabel?.font = editButtonLabel.titleLabel?.font.withSize(25)
        editButtonLabel.backgroundColor = buttonColor
        editButtonLabel.layer.cornerRadius = 6
        
        deleteButtonLabel.setTitleColor(textColor, for: .normal)
        deleteButtonLabel.titleLabel?.font = deleteButtonLabel.titleLabel?.font.withSize(25)
        deleteButtonLabel.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        deleteButtonLabel.layer.cornerRadius = 6
        
        taskListsButtonLabel.setTitleColor(textColor, for: .normal)
        taskListsButtonLabel.titleLabel?.font = editButtonLabel.titleLabel?.font.withSize(25)
        taskListsButtonLabel.backgroundColor = buttonColor
        taskListsButtonLabel.layer.cornerRadius = 6
        
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        tableId = UserDefaults.standard.value(forKey: "TableId") as! Int
        listId = UserDefaults.standard.value(forKey: "ListId") as! Int
        cardId = UserDefaults.standard.value(forKey: "CardId") as! Int
        
        view.addGestureRecognizer(tap)
        
        self.getComments()
        ApiClient.getCards(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId) { (result) in
            switch result {
            case .success(let cards):
                self.card = cards.getCard(withId: self.cardId)
                self.cardName.text = self.card.title
                self.cardDescription.text = (self.card.description?.isEmpty ?? true) ? "Write a decription here" : self.card.description
                
                
            case .failure(let error):
                print(error.localizedDescription)
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @objc func textFieldReturned() {
        if let comment = commentTextField.text {
            ApiClient.createComment(email: self.email, token: self.token, tableId: tableId, listId: listId, cardId: cardId, comment: comment) { (result) in
                switch result {
                case .success(let newComment):
                    self.comments.append(newComment.data)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension CardController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardComment", for: indexPath)
        cell.textLabel?.text = self.comments[indexPath.row].content
        cell.backgroundColor = backgroundColor
        if indexPath.row % 2 == 0 {
            cell.textLabel?.textAlignment = .left
        } else {
            cell.textLabel?.textAlignment = .right
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            ApiClient.deleteComment(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.cardId, commentId: self.comments[indexPath.row].id) { (result) in
                if result {
                    self.comments.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}



