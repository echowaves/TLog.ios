//
//  MenuViewController.swift
//  TLog
//
//  Created by D on 2/15/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import UIKit

class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func employeesButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("employeesSegue", sender: self)
        }
    }
    
    @IBAction func reportsButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("reportsSegue", sender: self)
        }
    }

    
    @IBAction func signOutButtonClicked(sender: AnyObject) {
        TLUser.clearJwtFromLocalStorage()
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("unwindToSignInSegue", sender: self)
        }

    }
}
