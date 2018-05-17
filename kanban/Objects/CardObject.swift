//
//  CardObject.swift
//  kanban
//
//  Created by Oleksii Furman on 17/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct CardObject: Codable {
    let data: [CardData]
}

struct CardData: Codable {
    let id: Int
    let title: String
    let description: String
}
