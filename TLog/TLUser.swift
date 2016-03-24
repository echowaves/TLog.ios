//
//  TLUser.swift
//  TLog
//
//  Created by D on 2/15/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire


class TLUser: NSObject {
    var id: Int?
    var email:String?
    var password:String?
    
    init(id: Int!, email:String!, password:String! ) {
        self.id = id
        self.email = email
        self.password = password
    }
    
    
    
    static let JWT_KEY:String = "TTLogJWT";
    static let ACTIVATION_CODE_KEY:String = "TTLogActivationCode";
    
    class func storeJwtLocally(jwt:String)  -> () {
        let keychain = KeychainSwift()
        keychain.set(jwt, forKey: TLUser.JWT_KEY)
    }
    
    class func retreiveJwtFromLocalStorage()  -> (String!) {
        let keychain = KeychainSwift()
        return keychain.get(TLUser.JWT_KEY)
    }
    
    class func clearJwtFromLocalStorage()  -> () {
        let keychain = KeychainSwift()
        keychain.delete(TLUser.JWT_KEY)
    }
    
    
    
    
    func signIn(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
        
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters = ["email": self.email!,
                          "password": self.password!]
        
        Alamofire.request(.POST, "\(TL_HOST)/auth" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                
                switch response.result {
                case .Success:
                    if let JSON = response.result.value {
                        //                            print("jwtToken:")
                        //                            print(JSON.valueForKey("token") as! String)
                        TLUser.storeJwtLocally(JSON.valueForKey("token") as! String)
                    }
                    success();
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
    func signUp(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters = ["email": self.email!,
                          "password": self.password!]
        Alamofire.request(.POST, "\(TL_HOST)/users" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.id = response.result.value!["id"] as? Int
                    
                    self.signIn(
                        { () -> () in
                            NSLog("authenticated")
                            
                            success();
                            
                    }) { (error) -> () in
                        NSLog("failed to authenticate")
                        failure(error: error)
                    }
                    
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
//    func currentUser(
//        success:() -> (),
//        failure:(error: NSError) -> ()) -> () {
//        let headers = [
//            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
//            "Content-Type": "application/json"
//        ]
//        Alamofire.request(.GET, "\(TL_HOST)/users", encoding: ParameterEncoding.JSON, headers: headers)
//            .validate(statusCode: 200..<300)
//            .responseJSON { response in
//                switch response.result {
//                case .Success:
//                    self.id = response.result.value!["id"] as? Int
//                    success();
//                case .Failure(let error):
//                    NSLog(error.description)
//                    failure(error: error)
//                }
//        }
//    }
    
    
}