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
            .responseString { (responce: DataResponse<String>) in
            completion(responce.result.isSuccess)
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
            .responseJSONDecodable { (responce: DataResponse<TableObject>) in
                completion(responce.result)
        }
    }
    
    static func createUserTable(email: String, token: String, name: String, isPrivate: Bool, completion: @escaping (Result<CreateTableObject>) -> Void) {
        Alamofire.request(ApiRouter.createTable(email: email, token: token, name: name, isPrivate: isPrivate))
            .debugLog()
            .responseJSONDecodable { (responce: DataResponse<CreateTableObject>) in
            completion(responce.result)
        }
    }
    
    static func deleteTable(email: String, token: String, tableId: Int, completion: @escaping (Bool) -> Void) {
        Alamofire.request(ApiRouter.deleteTable(email: email, token: token, tableId: tableId)).responseString { (responce: DataResponse<String>) in
            completion(responce.result.isSuccess)
        }
    }
    
    static func getLists(email: String, token: String, tableId: Int, completion: @escaping (Result<ListObject>) -> Void) {
        Alamofire.request(ApiRouter.getTableLists(email: email, token: token, tableId: tableId))
            .debugLog()
            .responseJSONDecodable { (responce: DataResponse<ListObject>) in
            completion(responce.result)
        }
    }
    
    static func createList(email: String, token: String, tableId: Int, name: String,
                           completion: @escaping (Result<CreateListObject>) -> Void) {
        Alamofire.request(ApiRouter.createTableList(email: email, token: token, tableId: tableId, listName: name))
            .debugLog()
            .responseJSONDecodable { (responce: DataResponse<CreateListObject>) in
            completion(responce.result)
        }
    }
    
    static func getCards(email: String, token: String, tableId: Int, listId: Int, completion: @escaping (Result<CardObject>) -> Void) {
        Alamofire.request(ApiRouter.getCards(email: email, token: token, tableId: tableId, listId: listId))
            .debugLog()
            .responseJSONDecodable { (responce: DataResponse<CardObject>) in
            completion(responce.result)
        }
    }
}









