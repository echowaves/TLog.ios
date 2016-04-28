//
//  EmployeeActionCodesPopoverViewController.swift
//  TLog
//
//  Created by D on 3/20/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift


class EmployeeActionCodesPopoverViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    var parentController:EmployeeActionCodesViewController!
    
    var actionCodes:[TLActionCode] = [TLActionCode]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("EmployeeActionCodesPopoverViewController")

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
        
        cell.actionCodeLabel!.text! = self.actionCodes[indexPath.row].code! + ":" + self.actionCodes[indexPath.row].descr!
        cell.addLabel.FAIcon = FAType.FAPlus

        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        add to employee action codes
//         self.actionCodes[indexPath.row]
        
        parentController.employee?.addActionCode(self.actionCodes[indexPath.row],
                                                 success: {
                                                    self.dismissViewControllerAnimated(true, completion: {
                                                        self.parentController.popoverVC = nil
                                                        self.parentController.actionCodeTextField.text = ""
                                                        self.parentController.updateActionCodes()
                                                    })

                                                    
            },
                                                 failure: { (error) in
                                                    NSLog(error.description)
                                                    let alert = UIAlertController(title: nil, message: "Unable to add action code for employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                                    alert.addAction(UIAlertAction(
                                                        title: "OK", style: UIAlertActionStyle.Default,
                                                        handler: { (UIAlertAction) in
                                                            self.presentViewController(alert, animated: true, completion: nil)
                                                            
                                                            self.parentController.popoverVC = nil
                                                            self.parentController.actionCodeTextField.text = ""
                                                            self.parentController.updateActionCodes()
   
                                                        })
                                                    )
                                                        

        })
        
        

    }

    
}

