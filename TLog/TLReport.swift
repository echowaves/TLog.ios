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
    
    class func monthsForUserAndYear(year:String,
                                    success:(years:[String]) -> (),
                                    failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        Alamofire.request(.GET, "\(TL_HOST)/reports/months/\(year)", encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    let json = JSON(data: response.data!)["months"]
                    var months = [String]()
                    for (_,jsonMonth):(String, JSON) in json {
                        months.append(jsonMonth["date_part"].stringValue)
                    }
                    success(years: months)
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
    
    
    class func employeeDurationsByYearMonthForUser(year:String,
                                                   month:String,
                                                   success:(employees:[(String, Int)]) -> (),
                                                   failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        Alamofire.request(.GET, "\(TL_HOST)/reports/employees/\(year)/\(month)", encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    let json = JSON(data: response.data!)["employees"]
                    var employees = [(String, Int)]()
                    for (_,jsonEmployee):(String, JSON) in json {
                        employees.append(
                            (
                                jsonEmployee["name"].stringValue,
                                jsonEmployee["sum"].intValue
                            )
                        )
                    }
                    success(employees: employees)
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
    
}