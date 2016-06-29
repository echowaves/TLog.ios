//
//  SubcontractorCreateViewController.swift
//  TLog
//
//  Created by D on 5/9/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators
import SwiftDate


class SubcontractorCreateViewController: UIViewController {
    var subcontractor:TLSubcontractor?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("SubcontractorCreateViewController")
        
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonClicked(sender: AnyObject) {
        var validationErrors:[String] = []
        if(!Validator.required(nameTextField.text!)) {
            validationErrors += ["Name is required."]
        }
        
        if( !Validator.maxLength(100)(nameTextField.text!)) {
            validationErrors += ["Name can't be longer than 100."]
        }
        
        if(validationErrors.count == 0) { // no validation errors, proceed
            // have to create a new one
            subcontractor = TLSubcontractor(id: nil,
                                  name: self.nameTextField.text!
//                                  coi_expires_at: self.coiExpiresAtField.text!.toDate(DateFormat.ISO8601Format(.Extended))!

                                  )
            subcontractor!.create(
                { (SubcontractorId: Int) -> () in
                    
                    self.subcontractor!.id = SubcontractorId
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.performSegueWithIdentifier("SubcontractorDetailsViewController", sender: self)
                    }
                    
                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Unable to create a Subcontractor. Try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
            
        } else { //there are validation errors, let's output them
            var errorString = ""
            for error in validationErrors {
                errorString += "\(error)\n\n"
            }
            
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SubcontractorDetailsViewController") {
            let destViewController = segue.destinationViewController as! SubcontractorDetailsViewController
            destViewController.subcontractor = self.subcontractor
        }
    }
    
}
