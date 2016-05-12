//
//  SubcontractorsViewController.swift
//  TLog
//
//  Created by D on 5/9/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import Font_Awesome_Swift


class SubcontractorsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var tableView: UITableView!
    
    var subcontractors:[TLSubcontractor] = []
    
    var selectedSubcontractor: TLSubcontractor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("SubcontractorsViewController")
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadSubcontractors()
    }
    
    
    func loadSubcontractors() {
        TLSubcontractor.loadAll({ (subcontractors) -> () in
            self.subcontractors = subcontractors
            
            if(subcontractors.count == 0) {
                let alert = UIAlertController(title: nil, message: "No Subcontractors yet? Start adding Subcontractors before you can see something here.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            self.tableView.reloadData()
            self.tableView.reloadInputViews()

        }) { (error) -> () in
            let alert = UIAlertController(title: nil, message: "Error loading Subcontractors. Try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func menuButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func addNewSubcontractorButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("SubcontractorCreateViewController", sender: self)
        }
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // table view
    ////////////////////////////////////////////////////////////////////////////////////////////
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subcontractors.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let subcontractor = self.subcontractors[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("SubcontractorTableViewCell") as? SubcontractorTableViewCell!
        cell!.nameLabel?.text = subcontractor.name
        if(subcontractor.coi_expires_at != nil) {
            cell!.coiExpiresAtLabel?.text = dateOnlyDateFormatter.stringFromDate((subcontractor.coi_expires_at)!)
            cell!.coiExpiresAtLabel?.backgroundColor = UIColor.whiteColor()
            cell!.coiExpiresAtLabel?.textColor = UIColor(rgb: 0x666666);
        } else {
            cell!.coiExpiresAtLabel?.text = "COI is invalid"
            cell!.coiExpiresAtLabel?.backgroundColor = UIColor.redColor()
            cell!.coiExpiresAtLabel?.textColor = UIColor.blackColor()
        }
        cell!.chevronLabel.FAIcon = FAType.FAChevronRight
        
        return cell!
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedSubcontractor = self.subcontractors[indexPath.row]
        // Let's assume that the segue name is called playerSegue
        // This will perform the segue and pre-load the variable for you to use
        
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("SubcontractorDetailsViewController", sender: self)
        }
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "SubcontractorDetailsViewController") {
            let destViewController = segue.destinationViewController as! SubcontractorDetailsViewController
            destViewController.subcontractor = self.selectedSubcontractor
            self.selectedSubcontractor = nil
        }
    }
    
        
    
    // this method is the entry point for unwinding to the beginning
    @IBAction func unwindToSubcontractors(segue: UIStoryboardSegue) {
    }
    
    
}
