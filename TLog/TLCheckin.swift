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

class TLCheckin: NSObject {

    var id: Int?
    var email:String?
    var userId: Int?
    var checkedInAt: NSDate?
    var duration: Int?
    var actionCodeId: Int?
    var actionCode:TLActionCode?
    
    init(checkedInAt: NSDate, actionCodeId: Int) {
        self.checkedInAt = checkedInAt
        self.actionCodeId = actionCodeId

    }

    init(id: Int,
        email: String,
        userId: Int,
        checkedInAt: NSDate,
        duration: Int,
        actionCodeId: Int,
        actionCode: TLActionCode) {
            self.id = id
            self.email = email
            self.userId = userId
            self.checkedInAt = checkedInAt
            self.duration = duration
            self.actionCodeId = actionCodeId
            self.actionCode = actionCode
    }

    
    func create(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
            let headers = [
                "Content-Type": "application/json"
            ]
            let parameters = [
                "checked_in_at": String(self.checkedInAt!),
                "action_code_id": String(self.actionCodeId!)
            ]
            
            Alamofire.request(.POST, "\(TL_HOST)/employees/\(TLEmployee.retreiveActivationCodeFromLocalStorage())/checkins" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { response in
                    switch response.result {
                    case .Success:
                        let returnedCheckIn:NSDictionary = (response.result.value!["result"])!! as! NSDictionary

                        self.id = returnedCheckIn["id"] as? Int
                        self.email = returnedCheckIn["email"] as? String
                        self.userId = returnedCheckIn["user_id"] as? Int
                        self.checkedInAt = returnedCheckIn["check_in_at"] as? NSDate
                        self.duration = returnedCheckIn["duration"] as? Int
                        self.actionCodeId = returnedCheckIn["action_code_id"] as? Int
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
                            email: jsonEmployee["email"].stringValue)

                        let jsonCheckins = JSON(data: response.data!)["checkins"]
                        var checkins = [TLCheckin]()

                        
                        
                        // Set date format
                        let dateFmt = NSDateFormatter()
//                        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
                        dateFmt.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

                        
                        
                        
 
                        for (_,jsonCheckin):(String, JSON) in jsonCheckins {
                            let actionCode =
                            TLActionCode(
                                id: jsonCheckin["action_code_id"].intValue,
                                code: jsonCheckin["code"].stringValue,
                                descr: jsonCheckin["description"].stringValue)
                            
                            let checkin =
                            TLCheckin(
                                id: jsonCheckin["id"].intValue,
                                email: jsonCheckin["email"].stringValue,
                                userId: jsonCheckin["user_id"].intValue,
                                checkedInAt:  dateFmt.dateFromString(jsonCheckin["checked_in_at"].stringValue)!,
                                duration: jsonCheckin["duration"].intValue,
                                actionCodeId: jsonCheckin["action_code_id"].intValue,
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

}