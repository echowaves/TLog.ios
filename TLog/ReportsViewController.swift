//
//  ReportsViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class ReportsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var years:[String] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
