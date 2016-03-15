//
//  ActionCodesViewController.swift
//  TLog
//
//  Created by D on 3/14/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class ActionCodesReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var year:String!
    var month:String!

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
        

//        self.loadYears()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    @IBAction func yearButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func loadYears() {
//        TLReport.yearsForUser({ (years) in
//            self.years = years
//            self.tableView.reloadData()
//            },
//                              failure: { (error) in
//                                let alert = UIAlertController(title: nil, message: "Error loading years. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
//                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
//                                self.presentViewController(alert, animated: true, completion: nil)
//            }
//            
//        )
//    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return years.count
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        let year = self.years[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("YearButtonTableViewCell") as? YearButtonTableViewCell!
//
//        cell!.yearButton?.setTitle(year, forState: .Normal)
//        cell!.yearButton?.tag = indexPath.row
//        cell!.yearButton?.addTarget(self, action: #selector(YearPickerViewController.yearButtonPushed), forControlEvents: .TouchUpInside)
//        
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
