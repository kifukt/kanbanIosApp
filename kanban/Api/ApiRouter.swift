//
//  ApiRouter.swift
//  kanban
//
//  Created by Oleksii Furman on 23/04/2018.
//  Copyright © 2018 Oleksii Furman. All rights reserved.
//

import Foundation
import Alamofire

extension Request {
    public func debugLog() -> Self {
        debugPrint("=========================")
        #if DEBUG
        debugPrint(self, separator: "\n")
        #endif
        debugPrint("=========================")
        return self
    }
}

enum ApiRouter: URLRequestConvertible  {
    case signIn(email: String, password: String)
    case signOut(email: String, token: String)
    
    case getUserTables(email: String, token: String)
    case showTable(email: String, token: String, tableId: Int)
    case createTable(email: String, token: String, name: String, groupId: Int?)
    case updateTable(email: String, token: String, name: String, tableId: Int)
    case deleteTable(email: String, token: String, tableId: Int)
    
    case getTableLists(email: String, token: String, tableId: Int)
    case createTableList(email: String, token: String, tableId: Int, listName: String)
    case deleteList(email: String, token: String, tableId: Int, listId: Int)
    
    case getCards(email: String, token: String, tableId: Int, listId: Int)
    case createCard(email: String, token: String, tableId: Int, listId: Int, title: String, description: String)
    case updateCard(email: String, token: String, tableId: Int, listId: Int, cardId: Int, title: String, description: String)
    case deleteCard(email: String, token: String, tableId: Int, listId: Int, cardId: Int)
    
    case getComments(email: String, token: String, tableId: Int, listId: Int, cardId: Int)
    case createComment(email: String, token: String, tableId: Int, listId: Int, cardId: Int, comment: String)
    case deleteComment(email: String, token: String, tableId: Int, listId: Int, cardId: Int, commentId: Int)
    
    case getUserGroups(email: String, token: String)
    case createGroup(email: String, token: String, groupName: String)
    case deleteGroup(email: String, token: String, groupId: Int)
    case changeLeader(email: String, token: String, groupId: Int, leaderId: Int)
    case addUserToGroup(email: String, token: String, groupId: Int, userEmail: String)
    case showGroup(email: String, token: String, groupId: Int)
    case removeUserFromGroup(email: String, token: String, groupId: Int, userId: Int)
    
    
    case register(email: String, password: String, passwordConfirmation: String)
    
    // MARK: - Method
    private var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        case .signOut:
            return .delete
            
        case .getUserTables:
            return .get
        case .showTable:
            return .get
        case .createTable:
            return .post
        case .updateTable:
            return .put
        case .deleteTable:
            return .delete
            
        case .getTableLists:
            return .get
        case .createTableList:
            return .post
        case .deleteList:
            return .delete
            
        case .getCards:
            return .get
        case .createCard:
            return .post
        case .updateCard:
            return .put
        case .deleteCard:
            return .delete
            
        case .getComments:
            return .get
        case .createComment:
            return .post
        case .deleteComment:
            return .delete
            
        case .getUserGroups:
            return .get
        case .createGroup:
            return .post
        case .deleteGroup:
            return .delete
        case .changeLeader:
            return .post
        case .addUserToGroup:
            return .post
        case .showGroup:
            return .get
        case .removeUserFromGroup:
            return .delete
            
        case .register:
            return .post
        }
    }
    
    private var path: String {
        switch self {
        case .signIn, .signOut:
            return "/sessions"
        case .register:
            return "/users"
        case .getUserTables, .createTable:
            return "/tables"
        case .showTable(email: _, token: _, tableId: let tableId):
            return "/tables/" + String(tableId)
        case .updateTable(email: _, token: _, name: _, tableId: let tableId):
            return "/tables/" + String(tableId)
        case .deleteTable(email: _, token: _, tableId: let tableId):
            return "/tables/" + String(tableId)
            
        case .getTableLists(email: _, token: _, tableId: let tableId):
            return "/tables/" + String(tableId) + "/lists"
        case .createTableList(email: _, token: _, tableId: let tableId, listName: _):
            return "/tables/" + String(tableId) + "/lists"
        case .deleteList(email: _, token: _, tableId: let tableId, listId: let listId):
            return "/tables/" + String(tableId) + "/lists/" + String(listId)
            
        case .getCards(email: _, token: _, tableId: let tableId, listId: let listId):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards"
        case .createCard(email: _, token: _, tableId: let tableId, listId: let listId, title: _, description: _):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards"
        case .updateCard(email: _, token: _, tableId: let tableId, listId: let listId, cardId: let cardId, title: _, description: _):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards/" + String(cardId)
        case .deleteCard(email: _, token: _, tableId: let tableId, listId: let listId, cardId: let cardId):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards/" + String(cardId)
            
        case .getComments(email: _, token: _, tableId: let tableId, listId: let listId, cardId: let cardId):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards/" + String(cardId) + "/comments"
        case .createComment(email: _, token: _, tableId: let tableId, listId: let listId, cardId: let cardId, comment: _):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards/" + String(cardId) + "/comments"
        case .deleteComment(email: _, token: _, tableId: let tableId, listId: let listId, cardId: let cardId, commentId: let commentId):
            return "/tables/" + String(tableId) + "/lists/" + String(listId) + "/cards/" + String(cardId) + "/comments/" + String(commentId)
            
        case .getUserGroups, .createGroup:
            return "/groups"
        case .deleteGroup(email: _, token: _, groupId: let groupId):
            return "/groups/" + String(groupId)
        case .changeLeader(email: _, token: _, groupId: let groupId, leaderId: _):
            return "/groups/" + String(groupId) + "/change_leader"
        case .addUserToGroup(email: _, token: _, groupId: let groupId, userEmail: _):
            return "/groups/" + String(groupId) + "/add_user_to_group"
        case .showGroup(email: _, token: _, groupId: let groupId):
            return "/groups/" + String(groupId)
        case .removeUserFromGroup(email: _, token: _, groupId: let groupId, userId: _):
            return "/groups/" + String(groupId) + "/remove_user_from_group"
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .signIn(let email, let password):
            return [K.APIParameterKey.password: password, K.APIParameterKey.email: email]
        case .signOut, .getUserTables, .getTableLists, .getCards, .getUserGroups, .showGroup, .getComments, .showTable,
             .deleteTable, .deleteCard, .deleteList, .deleteGroup, .deleteComment:
            return nil
        case .register(email: let email, password: let password, passwordConfirmation: let passwordConfirmation):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password, K.APIParameterKey.confirmation: passwordConfirmation]
        case .createTable(email: _, token: _, name: let name, groupId: let groupId):
            return [K.APIParameterKey.name: name, K.APIParameterKey.groupId: groupId ?? "null"]
        case .updateTable(email: _, token: _, name: let name, tableId: _):
            return [K.APIParameterKey.name: name]
            
        case .createTableList(email: _, token: _, tableId: _, listName: let name):
            return [K.APIParameterKey.name: name]
            
        case .createCard(email: _, token: _, tableId: _, listId: _, title: let title, description: let description):
            return [K.APIParameterKey.title: title, K.APIParameterKey.description: description]
        case .updateCard(email: _, token: _, tableId: _, listId: _, cardId: _, title: let title, description: let description):
            return [K.APIParameterKey.title: title, K.APIParameterKey.description: description]
            
        case .createComment(email: _, token: _, tableId: _, listId: _, cardId: _, comment: let comment):
            return [K.APIParameterKey.content: comment]
            
        case .createGroup(email: _, token: _, groupName: let groupName):
            return [K.APIParameterKey.name: groupName]
        case .changeLeader(email: _, token: _, groupId: _, leaderId: let leaderId):
            return [K.APIParameterKey.leaderId: leaderId]
        case .addUserToGroup(email: _, token: _, groupId: _, userEmail: let userEmail):
            return [K.APIParameterKey.email: userEmail]
        case .removeUserFromGroup(email: _, token: _, groupId: _, userId: let userId):
            return [K.APIParameterKey.userId: userId]
        }
    }
    
    private var headers: [String:String]? {
        switch self {
        case .signIn:
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
            
        case .signOut(email: let email, token: let token):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
            
        case .register:
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
            
        case .getUserTables(email: let email, token: let token):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .showTable(email: let email, token: let token, tableId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .createTable(email: let email, token: let token, name: _, groupId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .updateTable(email: let email, token: let token, name: _, tableId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .deleteTable(email: let email, token: let token, tableId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        
        case .getTableLists(email: let email, token: let token, tableId: _):
            return [HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .createTableList(email: let email, token: let token, tableId: _, listName: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .deleteList(email: let email, token: let token , tableId: _, listId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
            
        case .getCards(email: let email, token: let token, tableId: _, listId: _):
            return [HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .createCard(email: let email, token: let token, tableId: _, listId: _, title: _, description: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .updateCard(email: let email, token: let token, tableId: _, listId: _, cardId: _, title: _, description: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .deleteCard(email: let email, token: let token, tableId: _, listId: _, cardId: _):
            return [HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
            
        case .getComments(email: let email, token: let token, tableId: _, listId: _, cardId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .createComment(email: let email, token: let token, tableId: _, listId: _, cardId: _, comment: _):
            return [HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token,
                    HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        case .deleteComment(email: let email, token: let token, tableId: _, listId: _, cardId: _, commentId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
            
        case .getUserGroups(email: let email, token: let token):
            return [HTTPHeaderField.email.rawValue: email, HTTPHeaderField.token.rawValue: token]
        case .createGroup(email: let email, token: let token, groupName: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .deleteGroup(email: let email, token: let token, groupId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .changeLeader(email: let email, token: let token, groupId: _, leaderId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .addUserToGroup(email: let email, token: let token, groupId: _, userEmail: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .showGroup(email: let email, token: let token, groupId: _):
            return [HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .removeUserFromGroup(email: let email, token: let token, groupId: _, userId: _):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        }
    }
    
    //MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try K.ProductionServer.baseURL.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.httpMethod = method.rawValue
        
        if let headers = headers {
            urlRequest.allHTTPHeaderFields = headers
        }
        
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        return urlRequest
    }
}
