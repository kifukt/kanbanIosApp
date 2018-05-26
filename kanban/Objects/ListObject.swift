//
//  ListObject.swift
//  kanban
//
//  Created by Oleksii Furman on 16/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct ListObject: Codable {
    var data: [ListDatas]
}

struct CreateListObject: Codable {
    var data: List
}

struct List: Codable {
    let list: ListDatas
}

struct ListDatas: Codable {
    let id: Int
    let name: String
    var cards: [CardData]?
}
