//
//  PickActionCodeViewController.swift
//  TLog
//
//  Created by D on 3/2/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation



class PickActionCodeViewController: UIViewController,UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate {
    
    
    @IBOutlet weak var checkinButton: UIBarButtonItem!
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
            selector: "textFieldTextChanged:",
            name:UITextFieldTextDidChangeNotification,
            object: actionCodeTextField
        )
        
        
        tableView.hidden        =   true
        tableView.delegate      =   self
        tableView.dataSource    =   self
        checkinButton.enabled   =   false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func checkinButtonClicked(sender: AnyObject) {
        let checkin = TLCheckin(checkedInAt: checkinTime, actionCodeId: (selectedActionCode?.id)!)
        checkin.create({ () -> () in
               self.dismissViewControllerAnimated(true, completion: nil)
            }) { (error) -> () in
                let alert = UIAlertController(title: nil, message: "Unable to check in, Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
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
        if(checkinButton.enabled) {
            actionCodeTextField.text = ""
        }
        checkinButton.enabled      =   false
        selectedActionCode  = nil
        
        NSLog("searching for text: " + actionCodeTextField.text!); //the textView parameter is the textView where text was changed
        TLActionCode.autoComplete(actionCodeTextField.text!,
            success: { (results) -> () in
            
            self.tableView.hidden = false
            self.completions = results
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            
            }) { (error) -> () in
                NSLog("error autocompleting")
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
        checkinButton.enabled      =   true

        tableView.hidden = true
        NSLog("You selected cell #\(self.completions[indexPath.row])")
        actionCodeTextField.text = self.completions[indexPath.row].code! + ":" + self.completions[indexPath.row].descr!
        selectedActionCode = self.completions[indexPath.row]
    }
    

    
}
