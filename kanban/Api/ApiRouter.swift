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
    case createTable(email: String, token: String, name: String, isPrivate: Bool)
    //    case deleteTable(email: String, token: String)
    //
    //    case getTableLists(email: String, token: String)
    //    case createList(email: String, token: String, listName: String)
    //    case deleteList(email: String, token: String)
    
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
        case .createTable:
            return .post
            //        case .deleteTable:
            //            return .delete
            //
            //        case .getTableLists:
            //            return .get
            //        case .createList:
            //            return .post
            //        case .deleteList:
            //            return .delete
            
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
        case .getUserTables:
            return "/tables"
        case .createTable:
            return "/tables"
            
        }
    }
    
    //MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .signIn(let email, let password):
            return [K.APIParameterKey.password: password, K.APIParameterKey.email: email]
        case .signOut(email: _, token: _):
            return nil
        case .register(email: let email, password: let password, passwordConfirmation: let passwordConfirmation):
            return [K.APIParameterKey.email: email, K.APIParameterKey.password: password, K.APIParameterKey.confirmation: passwordConfirmation]
        case .getUserTables(email: _, token: _):
            return nil
        case .createTable(email: _, token: _, name: let name, isPrivate: let isPrivate):
            return [K.APIParameterKey.name: name, K.APIParameterKey.isPrivate:  isPrivate]
        }
    }
    
    private var headers: [String:String]? {
        switch self {
        case .signIn:
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        case .signOut(email: let email, token: let token):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email, HTTPHeaderField.token.rawValue: token]
        case .register:
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue]
        case .getUserTables(email: let email, token: let token):
            return [HTTPHeaderField.contentType.rawValue: ContentType.json.rawValue,
                    HTTPHeaderField.email.rawValue: email,
                    HTTPHeaderField.token.rawValue: token]
        case .createTable(email: let email, token: let token, name: _, isPrivate: _):
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
