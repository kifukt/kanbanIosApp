//
//  CreateTableObject.swift
//  kanban
//
//  Created by Oleksii Furman on 09/05/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct CreateTableObject: Codable {
    let data: UserObj
}

struct UserObj: Codable {
    let user: UserData
}

struct UserData: Codable {
    let id: Int
    let name: String
}
