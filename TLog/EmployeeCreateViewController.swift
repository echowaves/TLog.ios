//
//  EmployeeCreateViewController.swift
//  TLog
//
//  Created by D on 4/1/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators


class EmployeeCreateViewController: UIViewController {
    var employee:TLEmployee?
    
    
    @IBOutlet weak var nameTextField: UITextField!    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("EmployeeCreateViewController")

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
            employee = TLEmployee(id: nil,
                                  name: nameTextField.text!,
                                  email: emailTextField.text!)
            employee!.create(
                { (employeeId: Int) -> () in
                    
                    self.employee!.id = employeeId
                    
                    dispatch_async(dispatch_get_main_queue()){
                        self.performSegueWithIdentifier("EmployeeDetailsViewController", sender: self)
                    }

                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Unable to create an employee, perhaps an employee with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
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
        if (segue.identifier == "EmployeeDetailsViewController") {
            let destViewController = segue.destinationViewController as! EmployeeDetailsViewController
            destViewController.employee = self.employee
        }
    }
    
}
