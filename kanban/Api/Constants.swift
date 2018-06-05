//
//  Constants.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import UIKit

struct K {
    struct ProductionServer {
        static let baseURL = "http://kanban-project-management-api.herokuapp.com/v1"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let confirmation = "password_confirmation"
        static let name = "name"
        static let groupId = "group_id"
        static let title = "title"
        static let description = "description"
        static let leaderId = "leader_id"
        static let userId = "user_id"
        static let content = "content"
    }
}

struct AppColor {
    static let blue = UIColor(red: 18.0/255.0, green: 78.0/255.0, blue: 120.0/255.0, alpha: 1)
    static let beige = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 201.0/255.0, alpha: 1)
    static let green = UIColor(red: 214.0/255.0, green: 255.0/255.0, blue: 183.0/255.0, alpha: 1)
    static let yellow = UIColor(red: 245.0/255.0, green: 255.0/255.0, blue: 144.0/255.0, alpha: 1)
    static let orange = UIColor(red: 255.0/255.0, green: 193.0/255.0, blue: 94.0/255.0, alpha: 1)
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case email = "X-User-Email"
    case token = "X-User-Token"
}

enum ContentType: String {
    case json = "application/json"
}
