//
//  EmployeesReportViewController.swift
//  TLog
//
//  Created by D on 3/14/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeesReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var year:String!
    var month:String!
    
    var employees:[(String, Int)] = [(String, Int)]()
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var yearButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let months = dateFormatter.monthSymbols
        
        navBar.topItem?.title = months[Int(month)!-1]
        yearButton.title = "< \(year)"
        
        
        loadEmployees()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func yearButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadEmployees() {
        TLReport.employeeDurationsByYearMonthForUser(
            year,
            month: month,
            success: { (employees) in
                self.employees = employees
                self.tableView.reloadData()
            },
            failure: { (error) in
                let alert = UIAlertController(title: nil, message: "Error loading employees stats. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        )
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let employee = self.employees[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeesReportTableViewCell") as? EmployeesReportTableViewCell!
        
        cell!.nameLabel?.text = employee.0
//        NSLog("\(employee.1)")
        if(employee.1 != 0) {
            cell!.durationLabel?.text = "\(employee.1) hours"
        } else {
            cell!.durationLabel?.text = "--"
        }
        
        
        return cell!
        
    }
    
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    ////        self.selectedYear = self.years[indexPath.row]
    //
    //        // Let's assume that the segue name is called playerSegue
    //        // This will perform the segue and pre-load the variable for you to use
    //
    //
    //    }
    
    
    
}
