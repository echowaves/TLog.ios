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
    var employee:TLEmployee?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var activateButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
        if(self.employee != nil) {
            self.nameTextField.text = employee?.name
            self.emailTextField.text = employee?.email
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(employee == nil) {
            activateButton.hidden = true
            deleteButton.hidden = true
        } else {
            activateButton.hidden = false
            deleteButton.hidden = false
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
            if(employee == nil) {
                TLEmployee.create(
                    nameTextField.text!,
                    email: emailTextField.text!,
                    success: { (employeeId: Int) -> () in
                        self.activateButton.hidden = false
                        self.deleteButton.hidden = false
                        
                        self.employee = TLEmployee(id: employeeId,name: self.nameTextField.text!, email: self.emailTextField.text!)
                        
                        let alert = UIAlertController(title: nil, message: "Employee successfully created.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
 
                    }, failure: { (error) -> () in
                        let alert = UIAlertController(title: nil, message: "Unable to create an employee, perhaps an employee with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                })
                
            } else { //saving existing employee
                TLEmployee.update(
                    (employee?.id)!,
                    name: nameTextField.text!,
                    email: emailTextField.text!,
                    success: { () -> () in
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
            TLEmployee.activate(
                (self.employee?.id)!,
                success: { (activationCode:String) -> () in
                    
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
            
            TLEmployee.deactivate(
                (self.employee?.id)!,
                success: { () -> () in
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
            
            TLEmployee.delete(
                (self.employee?.id)!,
                success: { () -> () in
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
    
    // MailComposerDelegate requirement
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
