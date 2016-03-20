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

class EmployeeDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    var employee:TLEmployee?// this is used as a parameter to be passed from the other controllers
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var isSubcontractor: UISwitch!
    
    @IBOutlet weak var subcontractorDisclaimer: UILabel!
    
    @IBOutlet weak var activateButton: UIButton!
    @IBOutlet weak var subLabel: UILabel!
    
    @IBOutlet weak var actionCodesButton: UIButton!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        subcontractorDisclaimer.hidden = !self.isSubcontractor.on
        subLabel.hidden = !self.isSubcontractor.on
        if(self.employee != nil) { // if employee is passed into this controller
            self.nameTextField.text = employee?.name
            self.emailTextField.text = employee?.email
            self.isSubcontractor.on = (employee?.isSubcontractor)!
        } else {
            // otherwise create a default one
            self.employee = TLEmployee(id: nil ,name: self.nameTextField.text!, email: self.emailTextField.text!, isSubcontractor: self.isSubcontractor.on)
        }
        
        if(isSubcontractor.on) {
            self.subcontractorDisclaimer.hidden = false
            self.subLabel.hidden = false

        } else {
            self.subcontractorDisclaimer.hidden = true
            self.subLabel.hidden = true

        }

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if(employee?.id == nil) {
            activateButton.hidden = true
            actionCodesButton.hidden = true
            deleteButton.enabled = false
        } else {
            activateButton.hidden = false
            actionCodesButton.hidden = false
            deleteButton.enabled = true
            if(employee?.activationCode == nil) {
                self.activateButton.setTitle("activate", forState: UIControlState.Normal)
            } else {
                self.activateButton.setTitle("deactivate", forState: UIControlState.Normal)
            }
        }
    }
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
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
            // have to create a new one
            if(employee?.id == nil) {
                employee?.name = nameTextField.text!
                employee?.email = emailTextField.text!
                employee!.create(
                    { (employeeId: Int) -> () in
                        self.activateButton.hidden = false
                        self.actionCodesButton.hidden = false
                        self.deleteButton.enabled = true
                        
                        self.employee = TLEmployee(id: employeeId,name: self.nameTextField.text!, email: self.emailTextField.text!, isSubcontractor: self.isSubcontractor.on)
                        
                        let alert = UIAlertController(title: nil, message: "Employee successfully created.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
 
                    }, failure: { (error) -> () in
                        let alert = UIAlertController(title: nil, message: "Unable to create an employee, perhaps an employee with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                })
                
            } else { //saving existing employee
                employee?.name = nameTextField.text!
                employee?.email = emailTextField.text!
                employee?.isSubcontractor = isSubcontractor.on
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

            }
            
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

    
    @IBAction func activateButtonClicked(sender: AnyObject) {
        if(self.employee?.activationCode == nil) {
           self.employee!.activate(
                { (activationCode:String) -> () in
                    
                    self.activateButton.setTitle("deactivate", forState: UIControlState.Normal)
                    self.employee?.activationCode = activationCode
                    NSLog("new activation code: \(activationCode)")
                    NSLog("activation link: \(TL_HOST)/public/mobile_employee.html?activation_code=\(activationCode)")
                    
                    // Create email message
                    let emailController = MFMailComposeViewController()
                    emailController.mailComposeDelegate = self

                    if MFMailComposeViewController.canSendMail() {
                        emailController.setToRecipients(["\(self.emailTextField.text!)"])
                        emailController.setSubject("TLog actvation code")
                        emailController.setMessageBody("On your mobile device click the following link to be able to access your personal Trade Log: \(TL_HOST)/public/mobile_employee.html?activation_code=\(activationCode)", isHTML: false) // or true, if you prefer
                        self.presentViewController(emailController, animated: true, completion: nil)
                    }
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error activating employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
            
            self.activateButton.setTitle("activate", forState: UIControlState.Normal)
        } else {
            
            self.employee!.deactivate(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Employee successfuly deactivated.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.activateButton.setTitle("activate", forState: UIControlState.Normal)
                        self.employee?.activationCode = nil
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deactivating employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })

            
            self.activateButton.setTitle("deactivate", forState: UIControlState.Normal)
        }
    }

    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
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
        if(isSubcontractor.on) {
            self.subcontractorDisclaimer.hidden = false
            self.subLabel.hidden = false
        } else {
            self.subcontractorDisclaimer.hidden = true
            self.subLabel.hidden = true
        }
        saveButtonClicked(self)
    }
    
    // MailComposerDelegate requirement
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionCodesClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeeActionCodesViewController", sender: self)
        }

    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EmployeeActionCodesViewController") {
            let destViewController = segue.destinationViewController as! EmployeeActionCodesViewController
            destViewController.employee = self.employee
        }
    }

}
