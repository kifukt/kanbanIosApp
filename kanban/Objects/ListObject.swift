//
//  ListObject.swift
//  kanban
//
//  Created by Oleksii Furman on 16/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct ListObject: Codable {
    let data: [ListDatas]
}

struct ListDatas: Codable {
    let id: Int
    let name: String
}
