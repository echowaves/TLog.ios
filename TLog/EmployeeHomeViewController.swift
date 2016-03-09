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
    @IBOutlet weak var duratonLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var employee:TLEmployee!
    var checkins:[TLCheckin] = []
    var currentCheckin: TLCheckin!
    
    
    @IBAction func checkinButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("pickActionCodeSegue", sender: self)
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        loadCheckins()
    }
    
    
    func loadCheckins() {
        TLCheckin.getAllCheckins(0, pageSize: 100, success: { (employee, checkins) -> () in
            self.employee = employee
            self.checkins = checkins
            self.updateViews()
            }) { (error) -> () in
                let alert = UIAlertController(title: nil, message: "Error loading checkins. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
        
        
    }
    
    func updateViews() {
        navBar.topItem?.title = employee.name
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
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
        
        //format date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "hh:mm" //format style. Browse online to get a format that fits your needs.
        let dateString = dateFormatter.stringFromDate((checkin.checkedInAt)!)
        
        cell!.checkinAt?.text = dateString
        cell!.checkinAt?.text = String(checkin.duration!)
        cell!.actionCode?.text = String("\((checkin.actionCode?.code)!):\((checkin.actionCode?.descr)!)")
        
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
