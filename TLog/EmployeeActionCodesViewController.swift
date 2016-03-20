//
//  EmployeeActionCodesViewController.swift
//  TLog
//
//  Created by D on 3/18/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation



class EmployeeActionCodesViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource, UIPopoverPresentationControllerDelegate
{
    
    var popoverVC:EmployeeActionCodesPopoverViewController!
    
    var employee:TLEmployee?// this is used as a parameter to be passed from the other controllers
    
    @IBOutlet weak var actionCodeTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var completions = [TLActionCode]()
    var selectedActionCode:TLActionCode?
    var checkinTime = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        actionCodeTextField.becomeFirstResponder()
        actionCodeTextField.delegate = self
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(PickActionCodeViewController.textFieldTextChanged(_:)),
            name:UITextFieldTextDidChangeNotification,
            object: actionCodeTextField
        )
        
        
        tableView.hidden        =   true
        tableView.delegate      =   self
        tableView.dataSource    =   self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //    @IBAction func checkinButtonClicked(sender: AnyObject) {
    //        let checkin = TLCheckin(checkedInAt: checkinTime, actionCodeId: (selectedActionCode?.id)!)
    //        checkin.create({ () -> () in
    //            self.dismissViewControllerAnimated(true, completion: nil)
    //        }) { (error) -> () in
    //            let alert = UIAlertController(title: nil, message: "Unable to check in, Try again.", preferredStyle: UIAlertControllerStyle.Alert)
    //            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    //            self.presentViewController(alert, animated: true, completion: nil)
    //        }
    //
    //    }
    
    
    
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
        
        selectedActionCode  = nil
        
        if(actionCodeTextField.text!.characters.count > 0) {
            
            NSLog("searching for text: " + actionCodeTextField.text!); //the textView parameter is the textView where text was changed
            TLActionCode.autoComplete(actionCodeTextField.text!,
                                      success: { (results) -> () in
                                        if( self.popoverVC == nil) {
                                            self.popoverVC = self.storyboard?.instantiateViewControllerWithIdentifier("EmployeeActionCodesPopoverViewController") as! EmployeeActionCodesPopoverViewController
                                            self.popoverVC.modalPresentationStyle = .Popover
                                            self.popoverVC.preferredContentSize = CGSizeMake(400, 400)
                                            
                                            
                                            let popoverPresentationViewController = self.popoverVC.popoverPresentationController
                                            popoverPresentationViewController?.permittedArrowDirections = UIPopoverArrowDirection.Any
                                            popoverPresentationViewController?.delegate = self
                                            popoverPresentationViewController?.sourceView =             self.actionCodeTextField
                                            popoverPresentationViewController?.sourceRect =             self.actionCodeTextField.bounds
                                            self.presentViewController(self.popoverVC, animated: true, completion: nil)
                                        }
                                        
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
        return self.completions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeActionCodesTableCell") as UITableViewCell!
        
        cell.textLabel?.text = self.completions[indexPath.row].code! + ":" + self.completions[indexPath.row].descr!
        cell.textLabel?.textColor = UIColor(rgb: 0x0033cc)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.hidden = true
        NSLog("You selected cell #\(self.completions[indexPath.row])")
        actionCodeTextField.text = self.completions[indexPath.row].code! + ":" + self.completions[indexPath.row].descr!
        selectedActionCode = self.completions[indexPath.row]
    }
    
    //delegate method to make popovers to work on ipad
    func adaptivePresentationStyleForPresentationController(
        controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
}
