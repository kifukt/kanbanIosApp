//
//  TableObject.swift
//  kanban
//
//  Created by Oleksii Furman on 21/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct TableObject: Codable {
    let data: [TableDatas]
}

struct ShowTableObject: Codable {
    let data: Table
}

struct Table: Codable {
    let table: TableDatas
}

struct TableDatas: Codable {
    let id: Int
    let name: String
    let is_private: Bool
    let group_id: Int?
}
