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

    class func retreiveJwtFromLocalStorage(jwt:String)  -> (String) {
        let keychain = KeychainSwift()
        return keychain.get(TLUser.JTW_KEY)!
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
                        print(error)
                        failure(error: error)
                    }
                    
//                    print("request: ")
//                    print(response.request!)  // original URL request
//                    print("response: ")
//                    print(response.response!) // URL response
//                    print("data: ")
//                    print(response.data!)     // server data
//                    print("result: ")
//                    print(response.result)   // result of response serialization
                    

            }

            
    }
    

    
    
}