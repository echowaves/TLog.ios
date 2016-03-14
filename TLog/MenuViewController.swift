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
    
    @IBOutlet weak var navBar: UINavigationBar!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
            
        
    }
    
    @IBAction func employeesButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeesViewController", sender: self)
        }
    }
    
    @IBAction func reportsButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("YearPickerViewController", sender: self)
        }
    }

    
    @IBAction func signOutButtonClicked(sender: AnyObject) {
        TLUser.clearJwtFromLocalStorage()
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("unwindToSignInSegue", sender: self)
        }

    }
}
