//
//  ListCell.swift
//  kanban
//
//  Created by Oleksii Furman on 27/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var listName: UILabel!
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
