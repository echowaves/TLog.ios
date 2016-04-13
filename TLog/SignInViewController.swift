//
//  SignInViewController.swift
//  TLog
//
//  Created by D on 2/15/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //auto sign in
        if(TLEmployee.retreiveActivationCodeFromLocalStorage() != nil) {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("EmployeeHomeViewController", sender: self)
            }
        } else {
            if(TLUser.retreiveJwtFromLocalStorage() != nil) {
                dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("MenuViewController", sender: self)
                }
            }
        }
    }
    
    
    @IBAction func signUpButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("SignUpViewController", sender: self)
        }
    }
    
    
    @IBAction func signInButtonClicked(sender: AnyObject) {
        TLUser(id: nil, email: emailTextField.text!, password: passwordTextField.text!).signIn(
            { () -> () in
                NSLog("authenticated")
                
                
                dispatch_async(dispatch_get_main_queue()){
                    self.performSegueWithIdentifier("MenuViewController", sender: self)
                }
                
                
            }) { (error) -> () in
                NSLog("failed to authenticate")
                
                NSLog(error.description)
                let alert = UIAlertController(title: nil, message: "Unable to sign in, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // this method is the entry point for unwinding to the beginning
    @IBAction func unwindToSignIn(segue: UIStoryboardSegue) {
    }
    
}
