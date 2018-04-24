//
//  Constants.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let baseURL = "http://kanban-project-management-api.herokuapp.com/v1"
    }
    
    struct APIParameterKey {
        static let password = "password"
        static let email = "email"
        static let confirmation = "password_confirmation"
    }
}


enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
}

enum ContentType: String {
    case json = "application/json"
}
