//
//  CommentObject.swift
//  kanban
//
//  Created by Oleksii Furman on 05/06/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation

struct CommentObject: Codable {
    let data: [CommentData]
}

struct CreateCommentObject: Codable {
    let data: CommentData
}

struct CommentData: Codable {
    let id: Int
    let content: String
}
