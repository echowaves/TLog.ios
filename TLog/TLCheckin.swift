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
    var checkedOutAt: NSDate?
    var actionCodeId: Int?

    init(checkedInAt: NSDate, actionCodeId: Int) {
        self.checkedInAt = checkedInAt
        self.actionCodeId = actionCodeId

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
                        self.checkedOutAt = returnedCheckIn["check_out_at"] as? NSDate
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
                        
                        
                        success(employee: employee, checkins: [TLCheckin]());
                    case .Failure(let error):
                        NSLog(error.description)
                        failure(error: error)
                    }
            }
    }

}