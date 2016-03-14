//
//  MonthPickerViewController.swift
//  TLog
//
//  Created by D on 3/13/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class MonthPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var year:String!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var months:[String] = []
    var selectedMonth:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.loadMonths()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navBar.topItem?.title = year
    }
    
    
    @IBAction func yearButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadMonths() {
        TLReport.monthsForUserAndYear(
            self.year,
            success: { (months) in
                self.months = months
                self.tableView.reloadData()
            },
            failure: { (error) in
                let alert = UIAlertController(title: nil, message: "Error loading months. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        )
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return months.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let month = self.months[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("MonthButtonTableViewCell") as? MonthButtonTableViewCell!
        cell!.monthButton?.setTitle(month, forState: .Normal)
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedMonth = self.months[indexPath.row]
        
        
        // Let's assume that the segue name is called playerSegue
        // This will perform the segue and pre-load the variable for you to use
        
        //        dispatch_async(dispatch_get_main_queue()){
        //            self.performSegueWithIdentifier("employeeDetailsSegue", sender: self)
        //        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //        if (segue.identifier == "employeeDetailsSegue") {
        //            let destViewController = segue.destinationViewController as! EmployeeDetailsViewController
        //            destViewController.employee = self.selectedEmployee
        //            self.selectedEmployee = nil
        //        }
    }
    
    
}
