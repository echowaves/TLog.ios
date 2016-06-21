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
    var usersSubcontractors = [TLSubcontractor]()
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
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        TLSubcontractor.loadAll({ (allSubcontractors) in
            self.usersSubcontractors = allSubcontractors
            self.completions = allSubcontractors
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            
            if(self.usersSubcontractors.count > 0) {
                self.subcontractorTextField.enabled = false
                self.subcontractorTextField.placeholder = "pick from the list"
            }
            
        }) { (error) in
            NSLog(error.description)
        }
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func pickButtonClicked(sender: AnyObject) {
        employee.addToSubcontractor(selectedSubcontractor!,
                                    success: {
                                        self.dismissViewControllerAnimated(true, completion: nil)
        }) { (error) in
            let alert = UIAlertController(title: nil, message: "Unable to add employee to subcontractor.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func subcontractorsButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("SubcontractorCreateViewController", sender: self)
        }
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
            completions = usersSubcontractors
            tableView.reloadData()
            tableView.reloadInputViews()
        }
        pickButton.enabled      =   false
        selectedSubcontractor  = nil
        
        if(subcontractorTextField.text!.characters.count > 0) {
            NSLog("searching for text: " + subcontractorTextField.text!); //the textView parameter is the textView where text was changed

            
            
            self.completions =
                self.usersSubcontractors.filter({$0.name!.rangeOfString(subcontractorTextField.text!) != nil})
            self.tableView.reloadData()
            self.tableView.reloadInputViews()
            
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.completions.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("pickSubcontractorCell") as UITableViewCell!
        
        cell.textLabel?.text = self.completions[indexPath.row].name!
        cell.textLabel?.textColor = UIColor(rgb: 0x0033cc)
        
        return cell
        
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        pickButton.enabled      =   true
        
        //        completions = usersSubcontractor
        //        tableView.reloadData()
        //        tableView.reloadInputViews()
        
        NSLog("You selected cell #\(self.completions[indexPath.row])")
        subcontractorTextField.text = self.completions[indexPath.row].name!
        selectedSubcontractor = self.completions[indexPath.row]
    }
    // this method is the entry point for unwinding to the beginning
    @IBAction func unwindSubcontractor(segue: UIStoryboardSegue) {
    }

    
}
