//
//  EmployeeActionCodesViewController.swift
//  TLog
//
//  Created by D on 3/18/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift



class EmployeeActionCodesViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate
{
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    var popoverVC:EmployeeActionCodesPopoverViewController!
    
    var employee:TLEmployee?// this is used as a parameter to be passed from the other controllers
    
    @IBOutlet weak var actionCodeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var actionCodes = [TLActionCode]()
    var checkinTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = employee?.name
        
        actionCodeTextField.becomeFirstResponder()
        actionCodeTextField.delegate = self
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(PickActionCodeViewController.textFieldTextChanged(_:)),
            name:UITextFieldTextDidChangeNotification,
            object: actionCodeTextField
        )
        
        
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateActionCodes()
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func updateActionCodes() {
        TLActionCode.allActionCodesForEmployee(employee!,
                                               success: { (results) in
                                                self.actionCodes = results
                                                self.tableView.reloadData()
                                                self.tableView.reloadInputViews()
        }) { (error) in
            NSLog(error.description)
            let alert = UIAlertController(title: nil, message: "Unable to load action codes for employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(
                title: "OK", style: UIAlertActionStyle.Default,
                handler: { (UIAlertAction) in
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            )
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 500
        let currentString: NSString = actionCodeTextField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    
    func textFieldTextChanged(sender : AnyObject) {
        
        if(actionCodeTextField.text!.characters.count > 0) {
            
            NSLog("searching for text: " + actionCodeTextField.text!); //the textView parameter is the textView where text was changed
            TLActionCode.autoComplete(actionCodeTextField.text!,
                                      success: { (results) -> () in
                                        if( self.popoverVC == nil) {
                                            self.popoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("EmployeeActionCodesPopoverViewController") as! EmployeeActionCodesPopoverViewController
                                            self.popoverVC.parentController = self
                                            self.popoverVC.modalPresentationStyle = .Popover
                                            self.popoverVC.preferredContentSize = CGSizeMake(400, 400)
                                            
                                            
                                            let popoverPresentationViewController = self.popoverVC.popoverPresentationController
                                            popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.Any
                                            popoverPresentationViewController?.delegate = self
                                            popoverPresentationViewController?.sourceView =             self.actionCodeTextField
                                            popoverPresentationViewController?.sourceRect =             self.actionCodeTextField.bounds
                                            self.presentViewController(self.popoverVC, animated: true, completion: nil)
                                        }
                                        
                                        self.popoverVC.actionCodes = results
                                        self.popoverVC.tableView.reloadData()
                                        self.popoverVC.tableView.reloadInputViews()
                                        
            }) { (error) -> () in
                NSLog("error autocompleting")
            }
        } else {
            if( self.popoverVC != nil) {
                self.popoverVC.dismissViewControllerAnimated(true, completion: {
                    self.popoverVC = nil
                })
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.actionCodes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeActionCodesTableCell") as! EmployeeActionCodesTableCell!
        
        cell.actionCodeLabel.text = self.actionCodes[indexPath.row].code! + ":" + self.actionCodes[indexPath.row].descr!
        cell.deleteLabel.FAIcon = FAType.FATrash
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("You selected cell #\(self.actionCodes[indexPath.row])")
        // delete employee action code
        
        self.employee?.deleteActionCode(self.actionCodes[indexPath.row],
                                        success: {
                                            self.updateActionCodes()
            },
                                        failure: { (error) in
                                            NSLog(error.description)
                                            let alert = UIAlertController(title: nil, message: "Unable to delete action code for employee, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                            alert.addAction(UIAlertAction(
                                                title: "OK", style: UIAlertActionStyle.Default,
                                                handler: { (UIAlertAction) in
                                                    self.presentViewController(alert, animated: true, completion: nil)
                                                    
                                                    self.updateActionCodes()
                                                    
                                            })
                                            )
        })
    }
    
    //delegate method to make popovers to work on ipad
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
