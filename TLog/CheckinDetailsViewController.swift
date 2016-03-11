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
    
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        checkedInAt.text = defaultDateFormatter.stringFromDate((checkin.checkedInAt)!)
        
        let (h,m,_) = secondsToHoursMinutesSeconds(checkin.duration!)
        duration.text = "\(h) hour : \(m) minutes"
        actionCode.text = "\((checkin.actionCode?.code)!):\((checkin.actionCode?.descr)!)"
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
