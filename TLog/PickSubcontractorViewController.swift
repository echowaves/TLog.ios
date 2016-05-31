//
//  PickSubcontractorViewController.swift
//  TLog
//
//  Created by D on 5/30/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift


class PickSubcontractorViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var pickButton: UIBarButtonItem!
    @IBOutlet weak var subcontractorTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    var employee:TLEmployee!
    var usersSubcontractor = [TLSubcontractor]()
    var completions = [TLSubcontractor]()
    var selectedSubcontractor:TLSubcontractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("PickSubcontractorViewController")
        
        subcontractorTextField.becomeFirstResponder()
        subcontractorTextField.delegate = self
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(
            self,
            selector: #selector(PickActionCodeViewController.textFieldTextChanged(_:)),
            name:UITextFieldTextDidChangeNotification,
            object: subcontractorTextField
        )
        
        
        tableView.delegate      =   self
        tableView.dataSource    =   self
        pickButton.enabled   =   false
        
        TLActionCode.allActionCodesForEmployee( employee,
                                                success: { (results) in
                                                    self.usersSubcontractor = results
                                                    self.completions = results
                                                    self.tableView.reloadData()
                                                    self.tableView.reloadInputViews()
                                                    
                                                    if(self.usersSubcontractor.count > 0) {
                                                        self.subcontractorTextField.enabled = false
                                                        self.subcontractorTextField.placeholder = "pick from the list"
                                                    }
                                                    
        }) { (error) in
            NSLog(error.description)
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func pickButtonClicked(sender: AnyObject) {
        let checkin = TLCheckin(checkedInAt: checkinTime, actionCode: selectedSubcontractor!)
        checkin.create({ () -> () in
            self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error) -> () in
            let alert = UIAlertController(title: nil, message: "Unable to check in, Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func subcontractorsButtonClicked(sender: AnyObject) {
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool
    {
        let maxLength = 500
        let currentString: NSString = subcontractorTextField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    
    func textFieldTextChanged(sender : AnyObject) {
        if(pickButton.enabled) {
            subcontractorTextField.text = ""
            completions = usersSubcontractor
            tableView.reloadData()
            tableView.reloadInputViews()
        }
        pickButton.enabled      =   false
        selectedSubcontractor  = nil
        
        if(subcontractorTextField.text!.characters.count > 0) {
            NSLog("searching for text: " + subcontractorTextField.text!); //the textView parameter is the textView where text was changed
            TLActionCode.autoComplete(subcontractorTextField.text!,
                                      success: { (results) -> () in
                                        
                                        self.completions = results
                                        self.tableView.reloadData()
                                        self.tableView.reloadInputViews()
                                        
            }) { (error) -> () in
                NSLog("error autocompleting")
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        
        cell.textLabel?.text = self.completions[indexPath.row].code! + ":" + self.completions[indexPath.row].descr!
        cell.textLabel?.textColor = UIColor(rgb: 0x0033cc)
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pickButton.enabled      =   true
        
        //        completions = usersSubcontractor
        //        tableView.reloadData()
        //        tableView.reloadInputViews()
        
        NSLog("You selected cell #\(self.completions[indexPath.row])")
        subcontractorTextField.text = self.completions[indexPath.row].code! + ":" + self.completions[indexPath.row].descr!
        selectedSubcontractor = self.completions[indexPath.row]
    }
    
    
    
}
