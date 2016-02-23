//
//  EmployeeHomeViewController.swift
//  TLog
//
//  Created by D on 2/22/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeeHomeViewController: UIViewController {
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBAction func signOutButtonClicked(sender: AnyObject) {
        TLUser.clearActivationCodeFromLocalStorage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}
