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
}
