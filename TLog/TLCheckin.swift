//
//  TLCheckin.swift
//  TLog
//
//  Created by D on 3/2/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SwiftDate

class TLCheckin: NSObject {
    
    // Set date format
    
    
    var id: Int?
    var email:String?
    var userId: Int?
    var checkedInAt: NSDate?
    var duration: Int?
    var actionCode:TLActionCode?
    
    init(checkedInAt: NSDate, actionCode: TLActionCode) {
        self.checkedInAt = checkedInAt
        self.actionCode = actionCode
    }
    
    init(id: Int,
         email: String,
         userId: Int,
         checkedInAt: NSDate,
         duration: Int,
         actionCode: TLActionCode) {
        self.id = id
        self.email = email
        self.userId = userId
        self.checkedInAt = checkedInAt
        self.duration = duration
        self.actionCode = actionCode
        
    }
    
    
    func create(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Content-Type": "application/json"
        ]
        let parameters = [
            "checked_in_at": self.checkedInAt!.toString(.ISO8601Format(.Extended))!,
            "action_code_id": String((self.actionCode?.id)!)
        ]
        
        Alamofire.request(.POST, "\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let returnedCheckIn:NSDictionary = (response.result.value!["checkin"])!! as! NSDictionary
                    
                    self.id = returnedCheckIn["id"] as? Int
                    self.email = returnedCheckIn["email"] as? String
                    self.userId = returnedCheckIn["user_id"] as? Int
                    //                        self.checkedInAt = self.dateFmt.dateFromString((returnedCheckIn["checked_in_at"] as? String)!)
                    //                        self.duration = returnedCheckIn["duration"] as? Int
//                    self.actionCodeId = returnedCheckIn["action_code_id"] as? Int
                    success();
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
            "Content-Type": "application/json"
        ]
        let parameters = [
            "checked_in_at": self.checkedInAt!.toString(.ISO8601Format(.Extended))!,
            "action_code_id": String((self.actionCode?.id)!),
            "duration": String(self.duration!)
        ]
        
        Alamofire.request(.PUT, "\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins/\(self.id!)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    //                        let returnedCheckIn:NSDictionary = (response.result.value!["result"])!! as! NSDictionary
                    //
                    //                        self.id = returnedCheckIn["id"] as? Int
                    //                        self.email = returnedCheckIn["email"] as? String
                    //                        self.userId = returnedCheckIn["user_id"] as? Int
                    //                        self.checkedInAt = returnedCheckIn["check_in_at"] as? NSDate
                    //                        self.duration = returnedCheckIn["duration"] as? Int
                    //                        self.actionCodeId = returnedCheckIn["action_code_id"] as? Int
                    success();
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
    
    class func getAllCheckins(
        pageNumber: Int,
        pageSize: Int,
        success:(employee: TLEmployee, checkins: [TLCheckin]) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Content-Type": "application/json"
        ]
        
        NSLog("\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins")
        
        
        Alamofire.request(.GET, "\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins?page_number=\(pageNumber)&page_size=\(pageSize)" , encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let jsonEmployee = JSON(data: response.data!)["employee"]
                    let employee =
                        TLEmployee(
                            id: jsonEmployee["id"].intValue,
                            name: jsonEmployee["name"].stringValue,
                            email: jsonEmployee["email"].stringValue,
                            isSubcontractor: jsonEmployee["is_subcontractor"].boolValue
                    )
                    
                    let jsonCheckins = JSON(data: response.data!)["checkins"]
                    var checkins = [TLCheckin]()
                    
                    
                    
                    for (_,jsonCheckin):(String, JSON) in jsonCheckins {
                        let actionCode =
                            TLActionCode(
                                id: jsonCheckin["action_code_id"].intValue,
                                code: jsonCheckin["code"].stringValue,
                                descr: jsonCheckin["description"].stringValue)
                        
                        let checkinDate = jsonCheckin["checked_in_at"].stringValue.toDate(DateFormat.ISO8601Format(.Extended))!
                        
                        let interval = jsonCheckin["duration"]["hours"].intValue * 60 * 60 + jsonCheckin["duration"]["minutes"].intValue * 60 + jsonCheckin["duration"]["seconds"].intValue
                        
                        let checkin =
                            TLCheckin(
                                id: jsonCheckin["id"].intValue,
                                email: jsonCheckin["email"].stringValue,
                                userId: jsonCheckin["user_id"].intValue,
                                checkedInAt:  checkinDate,
                                duration: interval,
                                actionCode: actionCode)
                        
                        
                        checkins.append(checkin)
                        
                    }
                    
                    
                    success(employee: employee, checkins: checkins);
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
            "Content-Type": "application/json"
        ]
        Alamofire.request(.DELETE, "\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins/\(self.id!)" , encoding: ParameterEncoding.JSON, headers: headers)
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
    
}