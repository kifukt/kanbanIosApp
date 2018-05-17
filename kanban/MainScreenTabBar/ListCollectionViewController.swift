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
    var cards = [CardData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        ApiClient.getLists(email: UserDefaults.standard.value(forKey: "Email") as! String,
                           token: UserDefaults.standard.value(forKey: "Token") as! String,
                           tableId: UserDefaults.standard.value(forKey: "TableId") as! Int) { (result) in
                            switch result {
                            case .success(let list):
                                self.lists = list.data
                                self.collectionView?.reloadData()
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
        }
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
        return newButton
    }
    
//    func generateCards(with listId: Int) {
//        var cardsArray = [UIButton]()
//        ApiClient.getCards(email: UserDefaults.standard.value(forKey: "Email") as! String,
//                           token: UserDefaults.standard.value(forKey: "Token") as! String,
//                           tableId: UserDefaults.standard.value(forKey: "TableId") as! Int,
//                           listId: listId) { (result) in
//                            switch result {
//                            case .success(let card):
//                                for item in card.data {
//                                    cardsArray += [self.titleButton(withTitle: item.title)]
//                                }
//                                self.cards = card.data
//                            case .failure(let error):
//                                print(error.localizedDescription)
//                            }
//        }
//        let stackView = UIStackView(arrangedSubviews: cardsArray)
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        stackView.alignment = .fill
//        stackView.spacing = 10
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//
//
//
//
//    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 40))
        title.text = self.lists[indexPath.row].name
        title.textAlignment = .center
        cell.addSubview(title)
        cell.backgroundColor = UIColor.blue
        
        var cardsArray = [UIButton]()
        ApiClient.getCards(email: UserDefaults.standard.value(forKey: "Email") as! String,
                           token: UserDefaults.standard.value(forKey: "Token") as! String,
                           tableId: UserDefaults.standard.value(forKey: "TableId") as! Int,
                           listId: indexPath.row + 1) { (result) in
                            switch result {
                            case .success(let card):
                                for item in card.data {
                                    cardsArray += [self.titleButton(withTitle: item.title)]
                                }
                                self.cards = card.data
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
        }
        let stackView = UIStackView(arrangedSubviews: cardsArray)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        cell.addSubview(stackView)
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 100)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
