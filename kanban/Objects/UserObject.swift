//
//  UserObject.swift
//  kanban
//
//  Created by Oleksii Furman on 19/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct UserObject: Decodable {
    let data: UserParams
}

struct UserParams: Decodable {
    let user: User
}

struct User: Decodable {
    let email: String
    let authentication_token: String
}
