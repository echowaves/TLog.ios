//
//  TLEmployee.swift
//  TLog
//
//  Created by D on 2/20/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Alamofire

class TLEmployee: NSObject {

    init(id: Int, name:String, email:String) {
        self.id = id
        self.name = name
        self.email = email
    }
    
    var id: Int?
    var name:String?
    var email:String?
    var activationCode:String?
    
    class func create(
        name: String,
        email: String,
        success:(employeeId: Int) -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            let parameters = ["name": name, "email": email]
            Alamofire.request(.POST, "\(TL_HOST)/employees" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        success(employeeId: response.result.value!["id"] as! Int);
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }

    class func update(
        employeeId: Int,
        name: String,
        email: String,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            let parameters = ["name": name, "email": email]
            Alamofire.request(.PUT, "\(TL_HOST)/employees/\(employeeId)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
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


    class func delete(
        employeeId: Int,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.DELETE, "\(TL_HOST)/employees/\(employeeId)" , encoding: ParameterEncoding.JSON, headers: headers)
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

    
    class func activate(
        employeeId: Int,
        success:(activationCode: String) -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.POST, "\(TL_HOST)/employees/\(employeeId)/activation" , encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        success(activationCode: response.result.value!["activation_code"] as! String);
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }

    
    class func deactivate(
        employeeId: Int,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.DELETE, "\(TL_HOST)/employees/\(employeeId)/activation" , encoding: ParameterEncoding.JSON, headers: headers)
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