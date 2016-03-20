//
//  EmployeeActionCodesPopoverViewController.swift
//  TLog
//
//  Created by D on 3/20/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeeActionCodesPopoverViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var actionCodes:[TLActionCode] = [TLActionCode]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate      =   self
        tableView.dataSource    =   self

    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actionCodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeActionCodesPopoverTableCell") as! EmployeeActionCodesPopoverTableCell!
        
        cell.textLabel?.text = self.actionCodes[indexPath.row].code! + ":" + self.actionCodes[indexPath.row].descr!
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        delete
//         self.actionCodes[indexPath.row]
    }

    
}

