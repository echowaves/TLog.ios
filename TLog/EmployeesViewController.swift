//
//  EmployeesViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var activeInactiveSegmentedControl: UISegmentedControl!
    @IBAction func activeInactiveChanged(sender: UISegmentedControl) {
        switch activeInactiveSegmentedControl.selectedSegmentIndex
        {
        case 0:
            self.employees = self.activeEmployees
        case 1:
            self.employees = self.inactiveEmployees
        default:
            break; 
        }
        self.tableView.reloadData()
        self.tableView.reloadInputViews()
        
    }

    @IBOutlet weak var tableView: UITableView!
    
    var employees:[TLEmployee] = []
    var activeEmployees:[TLEmployee] = []
    var inactiveEmployees:[TLEmployee] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadEmployees()
    }
    
    
    func loadEmployees() {
        TLEmployee.loadAll({ (activeEmployees, inactiveEmployees) -> () in
                self.activeEmployees = activeEmployees
                self.inactiveEmployees = inactiveEmployees
                self.employees = self.activeEmployees
                self.tableView.reloadData()
                self.tableView.reloadInputViews()            
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
            self.performSegueWithIdentifier("employeeDetailsSegue", sender: self)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("EmployeeTableViewCellIdentifier") as? EmployeeTableViewCell!
        cell!.nameLabel?.text = employee.name
        cell!.emailLabel?.text = employee.email
        
        return cell!
        

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        self.tableView.contentInset = UIEdgeInsetsMake(0,100,0,0)
    }
    
}
