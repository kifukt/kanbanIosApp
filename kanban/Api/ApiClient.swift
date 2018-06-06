//
//  ApiClient.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import Alamofire

class ApiClient {
    static func signIn(email: String, password: String, completion: @escaping ( Result<UserObject>) -> Void) {
        Alamofire.request(ApiRouter.signIn(email: email, password: password))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<UserObject> ) in
                completion(response.result)
                print(response.result)
        }
    }
    
    static func signOut(email: String, token: String, completion: @escaping (Bool) -> Void ) {
        Alamofire.request(ApiRouter.signOut(email: email, token: token))
            .debugLog()
            .responseString { (response: DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func register(with email: String, password: String, passwordConfirmation: String, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.register(email: email, password: password, passwordConfirmation: passwordConfirmation))
            .debugLog()
            .responseString { ( response: DataResponse<String> ) in
                completion(response.result.isSuccess)
        }
    }
    
    static func getUserTables(email: String, token: String, completion: @escaping (Result<TableObject>) -> Void) {
        Alamofire.request(ApiRouter.getUserTables(email: email, token: token))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<TableObject>) in
                completion(response.result)
        }
    }
    
    static func showTable(email: String, token: String, tableId: Int, completion: @escaping (Result<ShowTableObject>) -> Void) {
        Alamofire.request(ApiRouter.showTable(email: email, token: token, tableId: tableId)).responseJSONDecodable { (response: DataResponse<ShowTableObject>) in
            completion(response.result)
        }
    }
    
    static func createUserTable(email: String, token: String, name: String, groupId: Int?, completion: @escaping (Result<CreateTableObject>) -> Void) {
        Alamofire.request(ApiRouter.createTable(email: email, token: token, name: name, groupId: groupId))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<CreateTableObject>) in
            completion(response.result)
        }
    }
    
    static func updateTable(email: String, token: String, name: String, tableId: Int, completion: @escaping (Result<ShowTableObject>) -> Void) {
        Alamofire.request(ApiRouter.updateTable(email: email, token: token, name: name, tableId: tableId)).responseJSONDecodable { (response: DataResponse<ShowTableObject>) in
            completion(response.result)
        }
    }
    
    static func deleteTable(email: String, token: String, tableId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteTable(email: email, token: token, tableId: tableId)).responseString { (response: DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func getLists(email: String, token: String, tableId: Int, completion: @escaping (Result<ListObject>) -> Void) {
        Alamofire.request(ApiRouter.getTableLists(email: email, token: token, tableId: tableId))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<ListObject>) in
            completion(response.result)
        }
    }
    
    static func createList(email: String, token: String, tableId: Int, name: String,
                           completion: @escaping (Result<CreateListObject>) -> Void) {
        Alamofire.request(ApiRouter.createTableList(email: email, token: token, tableId: tableId, listName: name))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<CreateListObject>) in
            completion(response.result)
        }
    }
    
    static func deleteList(email: String, token: String, tableId: Int, listId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteList(email: email, token: token, tableId: tableId, listId: listId))
            .debugLog()
            .responseString { (response: DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func getCards(email: String, token: String, tableId: Int, listId: Int, completion: @escaping (Result<CardObject>) -> Void) {
        Alamofire.request(ApiRouter.getCards(email: email, token: token, tableId: tableId, listId: listId))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<CardObject>) in
            completion(response.result)
        }
    }
    static func createCard(email: String, token: String, tableId: Int, listId: Int, title: String, description: String, completion: @escaping (Result<CreateCardObject>) -> Void) {
        Alamofire.request(ApiRouter.createCard(email: email, token: token, tableId: tableId, listId: listId, title: title, description: description))
            .debugLog()
            .responseJSONDecodable { (response: DataResponse<CreateCardObject>) in
                completion(response.result)
        }
    }
    
    static func updateCard(email: String, token: String, tableId: Int, listId: Int, cardId: Int, title: String, description: String, completion: @escaping (Result<CreateCardObject>) -> Void) {
        Alamofire.request(ApiRouter.updateCard(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId, title: title, description: description))
            .responseJSONDecodable { (response: DataResponse<CreateCardObject>) in
            completion(response.result)
        }
    }
    
    static func deleteCard(email: String, token: String, tableId: Int, listId: Int, cardId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteCard(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId)).responseString { (response:DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func getComments(email: String, token: String, tableId: Int, listId: Int, cardId: Int, completion: @escaping (Result<CommentObject>) -> Void) {
        Alamofire.request(ApiRouter.getComments(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId)).responseJSONDecodable { (response: DataResponse<CommentObject>) in
            completion(response.result)
        }
    }
    
    static func deleteComment(email: String, token: String, tableId: Int, listId: Int, cardId: Int, commentId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteComment(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId, commentId: commentId)).responseString { (response: DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func createComment(email: String, token: String, tableId: Int, listId: Int, cardId: Int, comment: String, completion: @escaping (Result<CreateCommentObject>) -> Void) {
        Alamofire.request(ApiRouter.createComment(email: email, token: token, tableId: tableId, listId: listId, cardId: cardId, comment: comment)).responseJSONDecodable { (response: DataResponse<CreateCommentObject>) in
            completion(response.result)
        }
    }
    
    static func getUserGroups(email: String, token: String, completion: @escaping (Result<GroupsObject>) -> Void) {
        Alamofire.request(ApiRouter.getUserGroups(email: email, token: token)).responseJSONDecodable { (response: DataResponse<GroupsObject>) in
            completion(response.result)
        }
    }
    
    static func createGroup(email: String, token: String, groupName: String, completion: @escaping (Result<CreateGroupObject>) -> Void ) {
        Alamofire.request(ApiRouter.createGroup(email: email, token: token, groupName: groupName)).responseJSONDecodable { (response: DataResponse<CreateGroupObject>) in
            completion(response.result)
        }
    }
    
    static func deleteGroup(email:String, token: String, groupId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteGroup(email: email, token: token, groupId: groupId)).responseString { (response: DataResponse<String>) in
            completion(response.result.isSuccess)
        }
    }
    
    static func changeLeader(email: String, token: String, groupId: Int, leaderId: Int, completion: @escaping (Result<ChangeLeaderObject>) -> Void) {
        Alamofire.request(ApiRouter.changeLeader(email: email, token: token, groupId: groupId, leaderId: leaderId)).responseJSONDecodable { (response: DataResponse<ChangeLeaderObject>) in
            completion(response.result)
        }
    }
    
    static func addUserToGroup(email: String, token: String, groupId: Int, userEmail: String, completion: @escaping (Result<GroupDataObject>) -> Void) {
        Alamofire.request(ApiRouter.addUserToGroup(email: email, token: token, groupId: groupId, userEmail: userEmail)).responseJSONDecodable { (response: DataResponse<GroupDataObject>) in
            completion(response.result)
        }
    }
    
    static func showGroup(email: String, token: String, groupId: Int, completion: @escaping (Result<GroupDataObject>) -> Void) {
        Alamofire.request(ApiRouter.showGroup(email: email, token: token, groupId: groupId)).responseJSONDecodable { (response: DataResponse<GroupDataObject>) in
            completion(response.result)
        }
    }
    
    static func removeUserFromGroup(email: String, token: String, groupId: Int, userId: Int, completion: @escaping (Result<GroupDataObject>) -> Void) {
        Alamofire.request(ApiRouter.removeUserFromGroup(email: email, token: token, groupId: groupId, userId: userId)).responseJSONDecodable { (response: DataResponse<GroupDataObject>) in
            completion(response.result)
        }
    }
    
}









