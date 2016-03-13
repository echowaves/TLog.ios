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
    
    
    
    class func yearsForUser(
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
                    var years = [String]()
                    for (_,jsonYear):(String, JSON) in json {
                        years.append(jsonYear["date_part"].stringValue)                        
                    }
                    success(years: years)
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
}