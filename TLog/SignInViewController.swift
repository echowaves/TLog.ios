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
    }
    
    @IBAction func signInButtonClicked(sender: AnyObject) {
        TLUser.signIn(
            emailTextField.text!,
            password: passwordTextField.text!,
            success: { () -> () in
                print("authenticated")
            }) { (error) -> () in
                print("failed to authenticate")
                print(error.description)
        }
    }
    
    func validate() {
        
    }
    
}
