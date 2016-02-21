//
//  EmployeeDetailViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators

class EmployeeDetailsViewController: UIViewController {
    var employee:TLEmployee?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var activateButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if(employee == nil) {
            activateButton.hidden = true
            deleteButton.hidden = true
        } else {
            activateButton.hidden = false
            deleteButton.hidden = false
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
//            TLUser.signUp(
//                emailTextField.text!,
//                password: passwordTextField.text!,
//                success: { () -> () in
//                    dispatch_async(dispatch_get_main_queue()){
//                        self.performSegueWithIdentifier("menuSegue", sender: self)
//                    }
//                    
//                }, failure: { (error) -> () in
//                    let alert = UIAlertController(title: nil, message: "Unable to sign up, perhaps user with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                    self.presentViewController(alert, animated: true, completion: nil)
//            })
            
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
    }

    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
    }
}
