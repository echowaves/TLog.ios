//
//  CheckinsViewController.swift
//  TLog
//
//  Created by D on 2/22/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift

class CheckinsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    
    @IBOutlet weak var checkinButton: UIButton!
    @IBOutlet weak var sinceLabel: UILabel!
    @IBOutlet weak var actionCodeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var currentEmployee:TLEmployee!
    var currentCheckins:[TLCheckin] = []
    var currentCheckin: TLCheckin!
    
    var selectedCheckin: TLCheckin!
    
    
    
    
    @IBAction func checkinButtonClicked(sender: AnyObject) {
        
        if(currentCheckin == nil) {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("PickActionCodeViewController", sender: self)
            }
        } else {
            //checkout here
            
            let alert = UIAlertController(title: nil, message: "Sure to checkout?", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                alert in
                NSLog("OK Pressed")
                
                var elapsedTime:Int = Int(NSDate().timeIntervalSinceDate(self.currentCheckin.checkedInAt!))
                if( elapsedTime > 8 * 60 * 60) { // greater then 8 hours
                    elapsedTime = 8 * 60 * 60;
                }
                
                self.currentCheckin.duration! = elapsedTime
                
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
        
        if(TLUser.isUserLogin() == false) {
            //            presentViewController(SignInViewController, animated: true, completion: nil)
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("CheckinsViewController")

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if(TLUser.isUserLogin() == true) {
            self.signOutButton.title = "< back"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loadCheckins()
    }
    
    
    func loadCheckins() {
        TLCheckin.getAllCheckins(0, pageSize: 100, success: { (employee, checkins) -> () in
            self.currentEmployee = employee
            self.currentCheckins = checkins
            self.currentCheckin = nil
            
            
            //iterate over checkins and find a current checkin that is active (duration == 0)
            for index in 0 ..< checkins.count {
                if checkins[index].duration! == 0 {
                    if self.currentCheckin == nil {
                        self.currentCheckin = checkins[index]
                        self.currentCheckins.removeAtIndex(index)
                    }
                }
            }
            self.updateViews()
            
        }) { (error) -> () in
            let alert = UIAlertController(title: nil, message: "Error loading checkins. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            //            self.updateViews()
        }
    }
    
    func updateViews() {
        navBar.topItem?.title = currentEmployee.name
        if (self.currentCheckin != nil) {
            self.checkinButton!.setTitle("Check Out", forState: .Normal)
            self.checkinButton.backgroundColor = UIColor(rgb: 0xFF0000) //red
            self.sinceLabel.hidden = false
            self.actionCodeLabel.hidden = false
            self.sinceLabel.text = "Since:\n\(defaultDateFormatter.stringFromDate((self.currentCheckin.checkedInAt)!))"
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
        return currentCheckins.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let checkin = self.currentCheckins[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckinTableViewCell") as? CheckinTableViewCell!
        let dateString = defaultDateFormatter.stringFromDate((checkin.checkedInAt)!)
        
        cell!.checkinAt?.text = dateString
        
        cell!.duration?.text = checkin.durationText()
        cell!.actionCode?.text = String("\((checkin.actionCode?.code)!):\((checkin.actionCode?.descr)!)")
        cell!.chevronLabel.FAIcon = FAType.FAChevronRight
        
        return cell!
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedCheckin = self.currentCheckins[indexPath.row]
        
        
        let elapsedTime:Int = Int(NSDate().timeIntervalSinceDate(self.selectedCheckin.checkedInAt!))
        if(elapsedTime > 7 * 24 * 60 * 60) {
            let alert = UIAlertController(title: nil, message: "Can not update checkins older than 7 days.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.performSegueWithIdentifier("CheckinDetailsViewControler", sender: self)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "CheckinDetailsViewControler") {
            let destViewController = segue.destinationViewController as! CheckinDetailsViewControler
            destViewController.checkin = self.selectedCheckin
            self.selectedCheckin = nil
        } else
            if (segue.identifier == "PickActionCodeViewController") {
                let destViewController = segue.destinationViewController as! PickActionCodeViewController
                destViewController.employee = self.currentEmployee
        }
        
        
    }
    
}
