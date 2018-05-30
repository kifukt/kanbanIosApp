//
//  CardController.swift
//  kanban
//
//  Created by Oleksii Furman on 28/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class CardController: UIViewController {

    @IBOutlet weak var cardName: UILabel!
    
    @IBOutlet weak var cardDescription: UITextView!
    
    @IBAction func editButton(_ sender: UIButton) {
    }
    
    @IBAction func deleteButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you shure?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: .default) { (alertC) in
            ApiClient.deleteCard(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId, cardId: self.card.id!) { (result) in
                if result {
                    let listsController = self.storyboard?.instantiateViewController(withIdentifier: "ListsController") as! ListsController
                    self.navigationController?.pushViewController(listsController, animated: true)
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
    
    var card: CardData!
    var email: String!
    var token: String!
    var tableId: Int!
    var listId: Int!
    var cardId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
        email = UserDefaults.standard.value(forKey: "Email") as! String
        token = UserDefaults.standard.value(forKey: "Token") as! String
        tableId = UserDefaults.standard.value(forKey: "TableId") as! Int
        listId = UserDefaults.standard.value(forKey: "ListId") as! Int
        cardId = UserDefaults.standard.value(forKey: "CardId") as! Int
        print(self.cardId)
        ApiClient.getCards(email: self.email, token: self.token, tableId: self.tableId, listId: self.listId) { (result) in
            switch result {
            case .success(let cards):
                self.card = cards.getCard(withId: self.cardId)
                print(self.card)
                self.cardName.text = self.card.title
                self.cardDescription.text = (self.card.description?.isEmpty ?? true) ? "Write a decription here" : self.card.description
                self.dismiss(animated: false, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
