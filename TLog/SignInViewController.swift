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
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.becomeFirstResponder()
        TLUser.clearJwtFromLocalStorage()
    }
    
    @IBAction func signInButtonClicked(sender: AnyObject) {
        TLUser.signIn(
            emailTextField.text!,
            password: passwordTextField.text!,
            success: { () -> () in
                NSLog("authenticated")
                
                
                let menuViewController =
                self.storyboard!.instantiateViewControllerWithIdentifier("MenuViewController")
                self.showViewController(menuViewController, sender: self)

                
            }) { (error) -> () in
                NSLog("failed to authenticate")

                NSLog(error.description)
                let alert = UIAlertController(title: nil, message: "Unable to sign in, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)                
        }
    }
    
    
}
