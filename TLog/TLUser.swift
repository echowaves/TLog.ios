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
    
    static let JTW_KEY:String = "TTLogJWT";
    
    class func storeJwtLocally(jwt:String)  -> () {
        let keychain = KeychainSwift()
        keychain.set(jwt, forKey: TLUser.JTW_KEY)
    }
    
    class func retreiveJwtFromLocalStorage()  -> (String!) {
        let keychain = KeychainSwift()
        return keychain.get(TLUser.JTW_KEY)
    }
    
    class func clearJwtFromLocalStorage()  -> () {
        let keychain = KeychainSwift()
        keychain.delete(TLUser.JTW_KEY)
    }
    
    
    
    class func signIn(
        email: String,
        password: String,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            
            let parameters = ["email": email,
                "password": password]
            
            Alamofire.request(.POST, "\(TL_HOST)/auth" , parameters: parameters, encoding: ParameterEncoding.JSON)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    
                    switch response.result {
                    case .Success:
                        if let JSON = response.result.value {
                            //                            print("jwtToken:")
                            //                            print(JSON.valueForKey("token") as! String)
                            storeJwtLocally(JSON.valueForKey("token") as! String)
                        }
                        success();
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }
    
    
    class func signUp(
        email: String,
        password: String,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let parameters = ["email": email,
                "password": password]
            Alamofire.request(.POST, "\(TL_HOST)/users" , parameters: parameters, encoding: ParameterEncoding.JSON)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        success();
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }
}