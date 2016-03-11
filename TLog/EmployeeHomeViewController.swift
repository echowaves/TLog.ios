//
//  EmployeeHomeViewController.swift
//  TLog
//
//  Created by D on 2/22/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeeHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var sinceLabel: UILabel!
    @IBOutlet weak var actionCodeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var employee:TLEmployee!
    var checkins:[TLCheckin] = []
    var currentCheckin: TLCheckin!
    
    let dateFormatter = NSDateFormatter()
    
    
    @IBAction func checkinButtonClicked(sender: AnyObject) {
        
        if(currentCheckin == nil) {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("pickActionCodeSegue", sender: self)
            }
        } else {
            //checkout here
            
            let alert = UIAlertController(title: nil, message: "Sure to checkout?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                alert in
                NSLog("OK Pressed")
                
                let elapsedTime = NSDate().timeIntervalSinceDate(self.currentCheckin.checkedInAt!)
                self.currentCheckin.duration! = Int(elapsedTime)
                self.currentCheckin.update({ () -> () in
                    self.loadCheckins()
                    },
                    failure: { (error) -> () in
                        self.loadCheckins()
                        let alert = UIAlertController(title: nil, message: "Error checking out. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                )
                }
            )
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signOutButtonClicked(sender: AnyObject) {
        TLEmployee.clearActivationCodeFromLocalStorage()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.timeStyle = .ShortStyle
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCheckins()
    }
    
    
    func loadCheckins() {
        TLCheckin.getAllCheckins(0, pageSize: 100, success: { (employee, checkins) -> () in
            self.employee = employee
            self.checkins = checkins
            self.currentCheckin = nil
            
            
            //iterate over checkins and find a current checkin that is active (duration == 0)
            for index in 0 ..< checkins.count {
                if checkins[index].duration! == 0 {
                    if self.currentCheckin == nil {
                        self.currentCheckin = checkins[index]
                        self.checkins.removeAtIndex(index)
                    }
                }
            }
            self.updateViews()
            
        }) { (error) -> () in
            let alert = UIAlertController(title: nil, message: "Error loading checkins. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            self.updateViews()
        }
    }
    
    func updateViews() {
        navBar.topItem?.title = employee.name
        if (self.currentCheckin != nil) {
            self.checkinButton!.setTitle("Check Out", forState: .Normal)
            self.checkinButton.backgroundColor = UIColor(rgb: 0xFF0000) //red
            self.sinceLabel.hidden = false
            self.actionCodeLabel.hidden = false
            self.sinceLabel.text = "Since:\n\(self.dateFormatter.stringFromDate((self.currentCheckin.checkedInAt)!))"
            self.actionCodeLabel.text = "\((self.currentCheckin.actionCode?.code)!):\((self.currentCheckin.actionCode?.descr)!)"
        } else {
            self.checkinButton!.setTitle("Check In", forState: .Normal)
            self.checkinButton.backgroundColor = UIColor(rgb: 0x00C333) //green
            self.sinceLabel.hidden = true
            self.actionCodeLabel.hidden = true
        }
        
        dispatch_async(dispatch_get_main_queue(),{ ()->() in
            self.tableView.reloadData()
        })
//        self.tableView.reloadInputViews()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkins.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let checkin = self.checkins[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckinTableViewCell") as? CheckinTableViewCell!
        let dateString = self.dateFormatter.stringFromDate((checkin.checkedInAt)!)
        
        cell!.checkinAt?.text = dateString
        cell!.duration?.text = String(checkin.duration!)
        cell!.actionCode?.text = String("\((checkin.actionCode?.code)!):\((checkin.actionCode?.descr)!)")
        
//        if checkin.duration! == 0 {
//            NSLog("index: \(indexPath.row)")
//            NSLog("duration: \(checkin.duration!)")
//            cell!.backgroundColor = UIColor(rgb: 0xe0e0eb)
//        }
        return cell!
        
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        self.selectedEmployee = self.employees[indexPath.row]
    //
    //
    //        // Let's assume that the segue name is called playerSegue
    //        // This will perform the segue and pre-load the variable for you to use
    //
    //        dispatch_async(dispatch_get_main_queue()){
    //            self.performSegueWithIdentifier("employeeDetailsSegue", sender: self)
    //        }
    //
    //    }
    
    
}
