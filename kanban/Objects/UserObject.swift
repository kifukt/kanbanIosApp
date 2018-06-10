//
//  UserObject.swift
//  kanban
//
//  Created by Oleksii Furman on 19/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct UserObject: Codable {
    let data: UserParams
}

struct UserParams: Codable {
    let user: User
}

struct User: Codable {
    let id: Int?
    let email: String
    let authentication_token: String?
}
