//
//  EmployeesViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift


class EmployeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activeInactiveSegmentedControl: UISegmentedControl!
    @IBAction func activeInactiveChanged(sender: UISegmentedControl) {
        self.filterActiveInactive()
    }
    
    func filterActiveInactive() {
        switch activeInactiveSegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.employees = self.allEmployees
        case 1:
            self.employees = self.activeEmployees
        case 2:
            self.employees = self.inactiveEmployees
        default:
            self.employees = self.allEmployees
            break;
        }
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    var employees:[TLEmployee] = []
    
    var allEmployees:[TLEmployee] = []
    var activeEmployees:[TLEmployee] = []
    var inactiveEmployees:[TLEmployee] = []
    
    var selectedEmployee: TLEmployee!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("EmployeesViewController")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadEmployees()
    }
    
    
    func loadEmployees() {
        TLEmployee.loadAll({ (allEmployees, activeEmployees, inactiveEmployees) -> () in
            self.allEmployees = allEmployees
            self.activeEmployees = activeEmployees
            self.inactiveEmployees = inactiveEmployees
            self.filterActiveInactive()
    
            if(allEmployees.count == 0) {
                let alert = UIAlertController(title: nil, message: "No employees yet? Start adding employees before you can see something here.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
        }) { (error) -> () in
            let alert = UIAlertController(title: nil, message: "Error loading employees. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addNewEmployeeButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeeCreateViewController", sender: self)
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let employee = self.employees[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeTableViewCell") as? EmployeeTableViewCell!
        cell!.nameLabel?.text = employee.name
        cell!.emailLabel?.text = employee.email
        cell!.isSubcontractorLabel?.hidden = !employee.isSubcontractor
        cell!.chevronLabel.FAIcon = FAType.FAChevronRight
        
        
        return cell!
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedEmployee = self.employees[indexPath.row]
        
        
        // Let's assume that the segue name is called playerSegue
        // This will perform the segue and pre-load the variable for you to use
        
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("EmployeeDetailsViewController", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EmployeeDetailsViewController") {
            let destViewController = segue.destinationViewController as! EmployeeDetailsViewController
            destViewController.employee = self.selectedEmployee
            self.selectedEmployee = nil
        }
    }
    
        
    // this method is the entry point for unwinding to the beginning
    @IBAction func unwindToEmployees(segue: UIStoryboardSegue) {
    }
    
    
    
}
