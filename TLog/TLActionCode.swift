//
//  TLActionCode.swift
//  TLog
//
//  Created by D on 3/3/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class TLActionCode: NSObject {
    
    var id: Int?
    var code:String?
    var descr:String?
    
    init(id: Int!, code:String!, descr:String!) {
        self.id = id
        self.code = code
        self.descr = descr
    }
    
    class func autoComplete(
        text: String,
        success:(results:[TLActionCode]) -> (),
        failure:(error: NSError!) -> ()
        ) -> () {
            let searchText = text.lowercaseString
            if(searchText == "") {
                success(results: [TLActionCode]())
            } else {
                let headers = [
                    "Content-Type": "application/json"
                ]
                Alamofire.request(.GET, "\(TL_HOST)/actioncodes/lookup/\(searchText)" , encoding: ParameterEncoding.JSON, headers: headers)
                    .validate(statusCode: 200..<300)
                    .responseJSON { response in
                        switch response.result {
                        case .Success:
                            
                            var actionCodes:[TLActionCode] = [TLActionCode]()
                            
                            let returnedCodes:NSArray = (response.result.value!["results"])!! as! NSArray
                            
                            for returnedCode in returnedCodes {
                                actionCodes.append(TLActionCode(
                                    id:    returnedCode["id"]! as! Int,
                                    code:  returnedCode["code"]! as! String,
                                    descr: returnedCode["description"]! as! String
                                    )
                                )
                            }
                            
                            success(results: actionCodes)
                        case .Failure(let error):
                            NSLog(error.description)
                            failure(error: error)
                        }
                }
            }
            
    }
    
    
    
    //        class func getAllCheckins(
    //            activation_code: String,
    //            success:() -> (),
    //            failure:(error: NSError) -> ()) -> () {
    //                let headers = [
    //                    "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
    //                    "Content-Type": "application/json"
    //                ]
    //                let parameters = ["name": name, "email": email]
    //                Alamofire.request(.PUT, "\(TL_HOST)/employees/\(employeeId)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
    //                    .validate(statusCode: 200..<300)
    //                    .responseJSON { response in
    //                        switch response.result {
    //                        case .Success:
    //                            success();
    //                        case .Failure(let error):
    //                            NSLog(error.description)
    //                            failure(error: error)
    //                        }
    //                }
    //        }
    
}