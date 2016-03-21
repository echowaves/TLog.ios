//
//  TLEmployee.swift
//  TLog
//
//  Created by D on 2/20/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import KeychainSwift


class TLEmployee: NSObject {
    var id: Int?
    var name:String?
    var email:String?
    var isSubcontractor:Bool
    var activationCode:String?
    
    init(id: Int!, name:String!, email:String!, isSubcontractor:Bool) {
        self.id = id
        self.name = name
        self.email = email
        self.isSubcontractor = isSubcontractor
    }
    
    class func storeActivationCodeLocally(activationCode:String)  -> () {
        let keychain = KeychainSwift()
        keychain.set(activationCode, forKey: TLUser.ACTIVATION_CODE_KEY)
    }
    
    class func retreiveActivationCodeFromLocalStorage()  -> (String!) {
        let keychain = KeychainSwift()
        return keychain.get(TLUser.ACTIVATION_CODE_KEY)
    }
    
    class func clearActivationCodeFromLocalStorage()  -> () {
        let keychain = KeychainSwift()
        keychain.delete(TLUser.ACTIVATION_CODE_KEY)
    }
    
    
    
    func create(
        success:(employeeId: Int) -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            let parameters = ["name": self.name!, "email": self.email!, "is_subcontractor": self.isSubcontractor.description]
            Alamofire.request(.POST, "\(TL_HOST)/employees" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        self.id = response.result.value!["employee"]!!["id"] as? Int
                        success(employeeId: self.id!);
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }
    
    func update(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            let parameters = ["name": self.name!, "email": self.email!, "is_subcontractor": self.isSubcontractor.description]
            Alamofire.request(.PUT, "\(TL_HOST)/employees/\(self.id!)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
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
    
    
    func delete(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.DELETE, "\(TL_HOST)/employees/\(self.id!)" , encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        self.id = nil
                        success();
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }
    
    
    func activate(
        success:(activationCode: String) -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.POST, "\(TL_HOST)/employees/\(self.id!)/activation" , encoding: ParameterEncoding.JSON, headers: headers)
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
    
    
    func deactivate(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.DELETE, "\(TL_HOST)/employees/\(self.id!)/activation" , encoding: ParameterEncoding.JSON, headers: headers)
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
    
    
    class func loadAll(
        success:(activeEmployees: [TLEmployee], inactiveEmployees: [TLEmployee]) -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
                "Content-Type": "application/json"
            ]
            Alamofire.request(.GET, "\(TL_HOST)/employees" , encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        
                        let json = JSON(data: response.data!)["employees"]
                        
                        var activeEmployees: [TLEmployee] = [TLEmployee]()
                        var inactiveEmployees: [TLEmployee] = [TLEmployee]()
                        
                        for (_,jsonEmployee):(String, JSON) in json {
                            let employee =
                            TLEmployee(
                                id: jsonEmployee["id"].intValue,
                                name: jsonEmployee["name"].stringValue,
                                email: jsonEmployee["email"].stringValue,
                                isSubcontractor: jsonEmployee["is_subcontractor"].boolValue)
                            
                            if(jsonEmployee["activation_code"] != nil) {
                                employee.activationCode = jsonEmployee["activation_code"].stringValue
                                activeEmployees.append(employee)
                            } else {
                                inactiveEmployees.append(employee)
                            }
                        }
                        
                        success(activeEmployees: activeEmployees, inactiveEmployees: inactiveEmployees);
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }
 
    
    func addActionCode(actionCode:TLActionCode,
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        Alamofire.request(.POST, "\(TL_HOST)/employees/\(self.id!)/actioncodes/\(actionCode.id!)" , encoding: ParameterEncoding.JSON, headers: headers)
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