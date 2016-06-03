//
//  EmployeeDetailViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators
import MessageUI

class EmployeeDetailsViewController: UIViewController {
    var employee:TLEmployee?// this is used as a parameter to be passed from the other controllers
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var isSubcontractor: UISwitch!
    @IBOutlet weak var subcontracgtorNameButton: UIButton!
    @IBOutlet weak var subcontractorDisclaimer: UILabel!
    @IBOutlet weak var isActive: UISwitch!
    @IBOutlet weak var isActiveLabel: UILabel!
    @IBOutlet weak var isActiveDisclamer: UILabel!
    @IBOutlet weak var actionCodesButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var checkinsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("EmployeeDetailsViewController")

//        nameTextField.becomeFirstResponder()
        
        self.nameTextField.text = employee?.name
        self.emailTextField.text = employee?.email
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        if(employee?.activationCode == nil) {
            self.isActive.on = false
            self.checkinsButton.hidden = true
        } else {
            self.isActive.on = true
            self.checkinsButton.hidden = false
        }
     
        if(employee?.subcontractor == nil) {
            isSubcontractor.on = false
            subcontracgtorNameButton.hidden = true
        } else {
            isSubcontractor.on = true
            subcontracgtorNameButton.hidden = false
            subcontracgtorNameButton.titleLabel?.text = self.employee?.subcontractor?.name
        }
        
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("unwindToEmployees", sender: self)
        }
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        var validationErrors:[String] = []
        if(!Validator.required(emailTextField.text!)) {
            validationErrors += ["Email is required."]
        }
        if(!Validator.required(nameTextField.text!)) {
            validationErrors += ["Name is required."]
        }
        
        if(!Validator.isEmail(emailTextField.text!)) {
            validationErrors += ["Wrong email format."]
        }
        if( !Validator.maxLength(100)(nameTextField.text!)) {
            validationErrors += ["Name can't be longer than 100."]
        }
        if( !Validator.maxLength(100)(emailTextField.text!)) {
            validationErrors += ["Email can't be longer than 100."]
        }
        
        if(validationErrors.count == 0) { // no validation errors, proceed
            employee?.name = nameTextField.text!
            employee?.email = emailTextField.text!
            employee!.update(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Employee successfully updated.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error, perhaps an employee with the same email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
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
    
    
    @IBAction func isActiveSwitched(sender: AnyObject) {
        self.view.endEditing(true)
        if isActive.on {
            
            self.employee!.activate(
                { (activationCode:String) -> () in
                    
                    self.employee?.activationCode = activationCode // this is a bit redundunt, since it's happening inside the model.
                    NSLog("new activation code: \(activationCode)")
                    NSLog("activation link: \(TL_HOST)/public/mobile_employee.html?activation_code=\(activationCode)")
                    
                    // Create email message
                    
                    let alert = UIAlertController(title: nil, message: "Employee successfuly activated, activation email is sent.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.checkinsButton.hidden = false

                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error activating employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
            
        } else {
            self.employee!.deactivate(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Employee successfuly deactivated.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.employee?.activationCode = nil
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    self.checkinsButton.hidden = true
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deactivating employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
        }
        
    }
    
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "Are you sure want to delete the employee?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            alert1 in
            NSLog("OK Pressed")
            
            self.employee!.delete(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Employee successfuly deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deleting employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
            
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func isSubcontractorSwitched(sender: AnyObject) {
        if(employee?.subcontractor != nil) {
            let alert = UIAlertController(title: nil, message: "Are you sure want to delete the employee from subcontractor?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                alert1 in
                NSLog("OK Pressed")
                
                self.employee?.deleteFromSubcontractor({
                    self.isSubcontractor.on = false
                    }, failure: { (error) in
                        NSLog("error deleeting employee from subcontractor", error)
                        self.isSubcontractor.on = true
                })
                
                })
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("PickSubcontractorViewController", sender: self)
            }            
        }
    }
    
//    // MailComposerDelegate requirement
//    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
//        dismissViewControllerAnimated(true, completion: nil)
//    }
    
    
    
    @IBAction func subcontractorNameClicked(sender: AnyObject) {
    }
    
    @IBAction func actionCodesClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeeActionCodesViewController", sender: self)
        }
        
    }
    
    @IBAction func checkinsClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("CheckinsViewController", sender: self)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EmployeeActionCodesViewController") {
            let destViewController = segue.destinationViewController as! EmployeeActionCodesViewController
            destViewController.employee = self.employee
        }
        
        if (segue.identifier == "CheckinsViewController") {
            _ = segue.destinationViewController as! CheckinsViewController
            TLUser.setUserLogin()
            TLEmployee.storeActivationCodeLocally((employee?.activationCode)!)
        }

    }
    
}
