//
//  SignUpViewController.swift
//  TLog
//
//  Created by D on 2/15/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import UIKit
import SwiftValidators


class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    
    @IBAction func signUpButtonClicked(sender: AnyObject) {

        var validationErrors:[String] = []
        if(!Validator.required(emailTextField.text!)) {
            validationErrors += ["Email is required."]
        }
        if(!Validator.required(passwordTextField.text!)) {
            validationErrors += ["Password is required."]
        }
        
        if(!Validator.isEmail(emailTextField.text!)) {
            validationErrors += ["Wrong email format."]
        }
        if( !Validator.minLength(8)(passwordTextField.text!)) {
            validationErrors += ["Password must be 8 or more characters."]
        }
        if( passwordTextField.text! != passwordConfirmTextField.text! ) {
            validationErrors += ["Password Confirm must match Password."]
        }
        if( !Validator.maxLength(50)(passwordTextField.text!)) {
            validationErrors += ["Password can't be longer than 50."]
        }
        if( !Validator.maxLength(100)(emailTextField.text!)) {
            validationErrors += ["Email can't be longer than 100."]
        }

        
        if(validationErrors.count == 0) { // no validation errors, proceed
            TLUser(id: nil, email: emailTextField.text!, password: passwordTextField.text!).signUp(
                { () -> () in
                    dispatch_async(dispatch_get_main_queue()){
                        self.performSegueWithIdentifier("MenuViewController", sender: self)
                    }
                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Unable to sign up, perhaps user with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
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

    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
