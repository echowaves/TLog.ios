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
            validationErrors += ["Password length must be 8 or more."]
        }
        if( passwordTextField.text! != passwordConfirmTextField.text! ) {
            validationErrors += ["Password Confirm must match password."]
        }
        
        if(validationErrors.count == 0) { // no validation errors, proceed
            
            
            TLUser.signUp(
                emailTextField.text!,
                password: passwordTextField.text!,
                success: { () -> () in
                    let menuViewController =
                    self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController")
                    self.showViewController(menuViewController, sender: self)
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Unable to sign up, perhaps user with this email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
        } else { //there are validation errors, let's output them
            var errorString = ""
            for error in validationErrors {
                errorString += "\(error)\n"
            }
            
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
        
    }

    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
