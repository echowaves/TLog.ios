//
//  EmployeeHomeViewController.swift
//  TLog
//
//  Created by D on 2/22/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeeHomeViewController: UIViewController
//, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var navBar: UINavigationBar!
  
    
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var sinceLabel: UILabel!
    @IBOutlet weak var duratonLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var activationCode:String = ""
    
    @IBAction func checkinButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("pickActionCodeSegue", sender: self)
        }
    }
    
    @IBAction func signOutButtonClicked(sender: AnyObject) {
        TLUser.clearActivationCodeFromLocalStorage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activationCode = TLUser.retreiveActivationCodeFromLocalStorage()!
        navBar.topItem?.title = "tet"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
}
