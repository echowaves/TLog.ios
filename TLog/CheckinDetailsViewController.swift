//
//  CheckinDetailsViewController.swift
//  TLog
//
//  Created by D on 3/3/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation

class CheckinDetailsViewControler: UIViewController {
    var checkin: TLCheckin!
    
    @IBOutlet weak var checkedInAt: UITextField!
    @IBOutlet weak var duration: UITextField!
    @IBOutlet weak var actionCode: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkedInAt.text = defaultDateFormatter.stringFromDate((checkin.checkedInAt)!)
        
        duration.text = checkin.durationExtendedText()
        actionCode.text = "\((checkin.actionCode?.code)!):\((checkin.actionCode?.descr)!)"
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "Are you sure want to delete the checkin?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            alert1 in
            NSLog("OK Pressed")
            
            self.checkin!.delete(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Checkin successfuly deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deleting checkin, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
            })
            
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
