//
//  MonthPickerViewController.swift
//  TLog
//
//  Created by D on 3/13/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class MonthPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var years:[String] = []
    var selectedYear:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadYears()
        
    }
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadYears() {
        TLReport.yearsForUser({ (years) in
            self.years = years
            self.tableView.reloadData()
            },
                              failure: { (error) in
                                let alert = UIAlertController(title: nil, message: "Error loading years. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        )
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return years.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let year = self.years[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("YearButtonTableViewCell") as? YearButtonTableViewCell!
        cell!.yearButton?.setTitle(year, forState: .Normal)
        return cell!
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedYear = self.years[indexPath.row]
        
        
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
