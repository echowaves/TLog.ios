//
//  TLReport.swift
//  TLog
//
//  Created by D on 3/12/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import KeychainSwift
import Alamofire
import SwiftyJSON

class TLReport: NSObject {
    
    
    
    func yearsForUser(
        success:(years:[String]) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        Alamofire.request(.GET, "\(TL_HOST)/reports/years", encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)["years"]
                    
                    for (_,jsonYear):(String, JSON) in json {
                        let year =
                            TLEmployee(
                                id: jsonEmployee["id"].intValue,
                                name: jsonEmployee["name"].stringValue,
                                email: jsonEmployee["email"].stringValue)
                        if(jsonEmployee["activation_code"] != nil) {
                            employee.activationCode = jsonEmployee["activation_code"].stringValue
                            activeEmployees.append(employee)
                        } else {
                            inactiveEmployees.append(employee)
                        }
                        
                        
                    }

                    
                    success();
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
}