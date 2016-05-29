//
//  TLSubcontractor.swift
//  TLog
//
//  Created by D on 5/9/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import SwiftDate


class TLSubcontractor: NSObject {
    var id: Int?
    var name:String?
    var coi_expires_at:NSDate?
    
    init(id: Int!, name:String!) {
        self.id = id
        self.name = name
    }
    init(id: Int!, name:String!, coi_expires_at:NSDate!) {
        self.id = id
        self.name = name
        self.coi_expires_at = coi_expires_at
    }
    
    
    
    func create(
        success:(SubcontractorId: Int) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        let parameters =
            ["name": self.name!]
        
        Alamofire.request(.POST, "\(TL_HOST)/subcontractors" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    self.id = response.result.value!["subcontractor"]!!["id"] as? Int
                    success(SubcontractorId: self.id!);
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
        let parameters =
            ["name": self.name!,
             "coi_expires_at": self.coi_expires_at!.toString(.ISO8601Format(.Extended))!]
        
        Alamofire.request(.PUT, "\(TL_HOST)/subcontractors/\(self.id!)" , parameters: parameters, encoding: ParameterEncoding.JSON, headers: headers)
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
        
        self.deleteCOI({
            print("+++++++++++++++ deleted COI")
            }, failure: { (error) in
                print("+++++++++++++++ error deleting COI")
        })

        Alamofire.request(.DELETE, "\(TL_HOST)/subcontractors/\(self.id!)" , encoding: ParameterEncoding.JSON, headers: headers)
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
    
    
    
    class func loadAll(
        success:(allSubcontractors: [TLSubcontractor]) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        Alamofire.request(.GET, "\(TL_HOST)/subcontractors" , encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    
                    let json = JSON(data: response.data!)["subcontractors"]
                    
                    var allSubcontractors: [TLSubcontractor] = [TLSubcontractor]()
                    
                    for (_,jsonSubcontractor):(String, JSON) in json {
                        let subcontractor =
                            TLSubcontractor(
                                id: jsonSubcontractor["id"].intValue,
                                name: jsonSubcontractor["name"].stringValue)
                        
                        let coi_expires_at = jsonSubcontractor["coi_expires_at"].stringValue.toDate(DateFormat.ISO8601Format(.Extended))
                        
                        if(coi_expires_at != nil) {
                            subcontractor.coi_expires_at = coi_expires_at
                        }
                        
                        allSubcontractors.append(subcontractor)
                        
                    }
                    
                    success(allSubcontractors: allSubcontractors);
                case .Failure(let error):
                    NSLog(error.description)
                    failure(error: error)
                }
        }
    }
    
    
    func uploadCOI(image: UIImage,
                   success:() -> (),
                   failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "application/json"
        ]
        
        Alamofire.upload(.POST,
                         "\(TL_HOST)/subcontractors/\(self.id!)/coi",
                         headers: headers,
                         multipartFormData: {
                            multipartFormData in
                            if let imageData = UIImagePNGRepresentation(TLSubcontractor.fixOrientation(image)) {
                                multipartFormData.appendBodyPart(data: imageData, name: "coi", fileName: "\(self.id!).png", mimeType: "image/png")
                            }
                            
                            //                            multipartFormData.appendBodyPart(data: expiresAt.toString()!.dataUsingEncoding(NSUTF8StringEncoding)!, name: "coi_expires_at")
                            
            }, encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        //                        debugPrint(response)
                        success()
                    }
                case .Failure(let error):
                    print(error)
                    failure(error: NSError(domain: "encoding", code: 0, userInfo: ["error":"error"]))
                }
            }
        )
    }
    
    
    func downloadCOI(
        success:(image: UIImage) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "image/png"
        ]
        //        Request.addAcceptableImageContentTypes(["image/png"])
        
        Alamofire.request(.GET,
            "\(TL_HOST)/subcontractors/\(self.id!)/coi" , encoding: ParameterEncoding.JSON, headers: headers)
            .responseImage { response in
                //                debugPrint(response)
                
                //                print(response.request)
                //                print(response.response)
                //                debugPrint(response.result)
                
                if let image = response.result.value {
                    //                    print("image downloaded: \(image)")
                    success(image: image)
                } else {
                    failure(error: NSError(domain: "image", code: 0, userInfo: ["download":"error"]))
                }
        }
    }
    
    
    func deleteCOI(
        success:() -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "image/png"
        ]
        Alamofire.request(.DELETE,
            "\(TL_HOST)/subcontractors/\(self.id!)/coi" , encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    success()
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }
    
    
    
    func hasCOI(
        success:(hasCIO: Bool) -> (),
        failure:(error: NSError) -> ()) -> () {
        let headers = [
            "Authorization": "Bearer \(TLUser.retreiveJwtFromLocalStorage())",
            "Content-Type": "image/png"
        ]
        //        Request.addAcceptableImageContentTypes(["image/png"])
        
        Alamofire.request(.GET,
            "\(TL_HOST)/subcontractors/\(self.id!)/coi_exists" , encoding: ParameterEncoding.JSON, headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .Success:
                    let json = JSON(data: response.data!)["value"].boolValue
                    success(hasCIO: json)
                case .Failure(let error):
                    failure(error: error)
                }
        }
    }
    
    
    
    
    
    class func fixOrientation(img:UIImage) -> UIImage {
        
        if (img.imageOrientation == UIImageOrientation.Up) {
            return img;
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.drawInRect(rect)
        
        let normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;
        
    }
}