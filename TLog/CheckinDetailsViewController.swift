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
        Localytics.tagEvent("CheckinDetailsViewController")

        
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
    
    
    
    @IBAction func checkedInAtClicked(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
//        datePickerView.maximumDate = NSDate()
//        datePickerView.minimumDate = 7.days.ago
        sender.inputView = datePickerView
        datePickerView.setDate(checkin.checkedInAt!, animated: false)
        datePickerView.addTarget(self, action: #selector(CheckinDetailsViewControler.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
        let originalDate = self.checkin.checkedInAt!
        self.checkin.checkedInAt = sender.date
        
        self.checkin.update({ () -> () in
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
            self.checkedInAt.text = defaultDateFormatter.stringFromDate(sender.date)
            
            
            },
                            failure: { (error) -> () in
                                let alert = UIAlertController(title: nil, message: "Unable to update date, can only update between now and 7 days ago, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                self.checkin.checkedInAt = originalDate
            }
        )
//        self.view.endEditing(true)
    }
    
    @IBAction func durationClicked(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.CountDownTimer
        sender.inputView = datePickerView
        dispatch_async(dispatch_get_main_queue()) {
            datePickerView.countDownDuration = NSTimeInterval(NSNumber(integer: self.checkin!.duration!).doubleValue)
        }
        
        datePickerView.addTarget(self, action: #selector(CheckinDetailsViewControler.durationPickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }


    func durationPickerValueChanged(sender:UIDatePicker) {
        let originalDuration = self.checkin.duration!
        self.checkin!.duration = Int(sender.countDownDuration)
        
        self.checkin.update({ () -> () in
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle
            self.duration.text = self.checkin.durationExtendedText()
            
            },
                            failure: { (error) -> () in
                                let alert = UIAlertController(title: nil, message: "Unable to update duration, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                self.checkin.duration = originalDuration
            }
        )
//        self.view.endEditing(true)
    }

}
