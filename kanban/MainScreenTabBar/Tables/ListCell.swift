//
//  ListCell.swift
//  kanban
//
//  Created by Oleksii Furman on 27/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

protocol OptionButtonsDelegate{
    func deleteTapped(at index:IndexPath)
    func showList(at index: IndexPath)
}

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var listNameButton: UIButton!
    
    @IBAction func listButtonTapped(_ sender: UIButton) {
        self.delegate.showList(at: indexPath)
    }
    
    @IBAction func deleteListAction(_ sender: UIButton) {
        self.delegate?.deleteTapped(at: indexPath)
    }
    var delegate: OptionButtonsDelegate!
    
    var indexPath: IndexPath!
    
    @IBOutlet weak var tableView: UITableView!
    
    func setTableViewDataSourceDelegate<D: UITableViewDataSource & UITableViewDelegate>(dataSourceDelegate: D, forRow row: Int) {
        tableView.delegate = dataSourceDelegate
        tableView.dataSource = dataSourceDelegate
        tableView.tag = row
        tableView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        get {
            return tableView.contentOffset.x
        }
        set {
            tableView.contentOffset.x = newValue
        }
    }
}
