//
//  SubcontractorDetailsViewController.swift
//  TLog
//
//  Created by D on 5/9/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators
import MessageUI

class SubcontractorDetailsViewController: UIViewController {
    var subcontractor:TLSubcontractor?// this is used as a parameter to be passed from the other controllers
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var coiExpiresAtField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("SubcontractorDetailsViewController")
        
        //        nameTextField.becomeFirstResponder()
        
        self.nameTextField.text = subcontractor?.name
        self.coiExpiresAtField.text = defaultDateFormatter.stringFromDate((self.subcontractor?.coi_expires_at)!)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("unwindToSubcontractors", sender: self)
        }
    }
    
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        var validationErrors:[String] = []
        if(!Validator.required(nameTextField.text!)) {
            validationErrors += ["Name is required."]
        }
        if( !Validator.maxLength(100)(nameTextField.text!)) {
            validationErrors += ["Name can't be longer than 100."]
        }
        
        if(validationErrors.count == 0) { // no validation errors, proceed
            subcontractor?.name = nameTextField.text!
            subcontractor?.coi_expires_at = NSDate() // TODO: replace
            subcontractor!.update(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Subcontractor successfully updated.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error, perhaps an Subcontractor with the same email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "Are you sure want to delete the Subcontractor?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            alert1 in
            NSLog("OK Pressed")
            
            self.subcontractor!.delete(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Subcontractor successfuly deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deleting Subcontractor, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
            
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
            
    
    @IBAction func actionCodesClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("SubcontractorActionCodesViewController", sender: self)
        }
        
    }
    
    @IBAction func checkinsClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("CheckinsViewController", sender: self)
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "SubcontractorActionCodesViewController") {
//            let destViewController = segue.destinationViewController as! SubcontractorActionCodesViewController
//            destViewController.Subcontractor = self.Subcontractor
//        }
//        
//        if (segue.identifier == "CheckinsViewController") {
//            _ = segue.destinationViewController as! CheckinsViewController
//            TLUser.setUserLogin()
//            TLSubcontractor.storeActivationCodeLocally((Subcontractor?.activationCode)!)
//        }
        
    }
    
}
