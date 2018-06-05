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
    
    @IBOutlet weak var cardDescription: UITextView!
    
    var backgroundColor = AppColor.beige
    
    @IBOutlet weak var editButtonLabel: UIButton!
    @IBAction func editButton(_ sender: UIButton) {
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
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func sendCommentTapped(_ sender: UIButton) {
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
        commentTextField.delegate = self
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.tabBarController?.tabBar.isHidden = true
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = backgroundColor
        alert.view.addSubview(loadingIndicator)
        self.view.backgroundColor = backgroundColor
        cardName.font = cardName.font.withSize(50)
        cardName.layer.borderColor = backgroundColor.cgColor
        cardName.layer.cornerRadius = 6
        cardName.layer.borderWidth = 3
        cardName.backgroundColor = AppColor.yellow
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
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



