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
        Localytics.tagEvent("MonthPickerViewController")

        self.tableView.delegate = self
        self.tableView.dataSource = self

        navBar.topItem?.title = year

        self.loadMonths()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        
        let months = dateFormatter.monthSymbols
        let monthSymbol = months[Int(month)!-1]
        
        cell!.monthLabel.text = monthSymbol
        
        cell!.actionCodesButton?.tag = indexPath.row
        cell!.actionCodesButton?.addTarget(self, action: #selector(MonthPickerViewController.actionCodesButtonPushed), forControlEvents: .TouchUpInside)
        cell!.employeesButton?.tag = indexPath.row
        cell!.employeesButton?.addTarget(self, action: #selector(MonthPickerViewController.employeesButtonPushed), forControlEvents: .TouchUpInside)

        return cell!
        
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
    
    
    
    func actionCodesButtonPushed(sender:UIButton) {
        self.selectedMonth = self.months[sender.tag]
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("ActionCodesReportViewController", sender: self)
        }
    }

    
    func employeesButtonPushed(sender:UIButton) {
        self.selectedMonth = self.months[sender.tag]
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeesReportViewController", sender: self)
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ActionCodesReportViewController") {
            let destViewController = segue.destinationViewController as! ActionCodesReportViewController
            destViewController.year = self.year
            destViewController.month = self.selectedMonth
            self.selectedMonth = nil
        }
        if (segue.identifier == "EmployeesReportViewController") {
            let destViewController = segue.destinationViewController as! EmployeesReportViewController
            destViewController.year = self.year
            destViewController.month = self.selectedMonth
            self.selectedMonth = nil
        }

    }

    
}
