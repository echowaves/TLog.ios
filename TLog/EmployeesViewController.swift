//
//  EmployeesViewController.swift
//  TLog
//
//  Created by D on 2/16/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class EmployeesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var employees:[TLEmployee] = []
    
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
        TLEmployee.loadAll({ (employees) -> () in
                self.employees = employees
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
