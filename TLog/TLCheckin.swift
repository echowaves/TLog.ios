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

//    class func getAllCheckins(
//        activation_code: String,
//        success:() -> (),
//        failure:(error: NSError) -> ()) -> () {
//            let headers = [
//                "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
//                "Content-Type": "application/json"
//            ]
//            let parameters = ["name": name, "email": email]
//            Alamofire.request(.PUT, "\(TL_HOST)/employees/\(employeeId)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
//                .validate(statusCode: 200..<300)
//                .responseJSON { response in
//                    switch response.result {
//                    case .Success:
//                        success();
//                    case .Failure(let error):
//                        NSLog(error.description)
//                        failure(error: error)
//                    }
//            }
//    }

}