//
//  SubcontractorDetailsViewController.swift
//  TLog
//
//  Created by D on 5/9/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import Foundation
import SwiftValidators
import MessageUI
import Font_Awesome_Swift


class SubcontractorDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var firstTimeLoaded = true
    var subcontractor:TLSubcontractor?// this is used as a parameter to be passed from the other controllers
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var coiExpiresAtField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Localytics.tagEvent("SubcontractorDetailsViewController")
        
        //        nameTextField.becomeFirstResponder()
        
        self.nameTextField.text = subcontractor?.name
        if(self.subcontractor?.coi_expires_at != nil) {
            self.coiExpiresAtField.text = dateOnlyDateFormatter.stringFromDate((self.subcontractor?.coi_expires_at)!)
        }

        takePhotoButton.setFAIcon(FAType.FACamera, forState: .Normal)
        downloadButton.setFAIcon(FAType.FADownload, forState: .Normal)

        firstTimeLoaded = true
        
        imagePicker.delegate = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
//        if(firstTimeLoaded == true) {
//            if(subcontractor?.coi_expires_at == nil) {
//                takePhotoButtonClicked(takePhotoButton)
//            }
//        } else {
//            if(subcontractor?.coi_expires_at == nil) {
//               backButtonClicked(backButton)
//            }
//        }
        
        subcontractor?.downloadCOI({ (image) in
            self.imageView.image = image
            self.imageView.contentMode = .ScaleAspectFit
            }, failure: { (error) in
                print(error)
        })
    }
    
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()){
            self.performSegueWithIdentifier("unwindToSubcontractors", sender: self)
        }
    }
    
    
    @IBAction func saveButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        var validationErrors:[String] = []
        if(!Validator.required(nameTextField.text!)) {
            validationErrors += ["Name is required."]
        }
        if( !Validator.maxLength(100)(nameTextField.text!)) {
            validationErrors += ["Name can't be longer than 100."]
        }
        
        if(validationErrors.count == 0) { // no validation errors, proceed
            subcontractor?.name = nameTextField.text!
//            subcontractor?.coi_expires_at = NSDate() // TODO: replace
            subcontractor!.update(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Subcontractor successfully updated.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }, failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error, perhaps an Subcontractor with the same email already exists.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
            
        } else { //there are validation errors, let's output them
            var errorString = ""
            for error in validationErrors {
                errorString += "\(error)\n\n"
            }
            
            let alert = UIAlertController(title: nil, message: errorString, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func deleteButtonClicked(sender: AnyObject) {
        self.view.endEditing(true)
        let alert = UIAlertController(title: nil, message: "Are you sure want to delete the Subcontractor?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
            alert1 in
            NSLog("OK Pressed")
            
            self.subcontractor!.delete(
                { () -> () in
                    let alert = UIAlertController(title: nil, message: "Subcontractor successfuly deleted.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                        alert2 in
                        self.dismissViewControllerAnimated(true, completion: nil)
                        })
                    self.presentViewController(alert, animated: true, completion: nil)
                },
                failure: { (error) -> () in
                    let alert = UIAlertController(title: nil, message: "Error deleting Subcontractor, try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
            })
            
            })
        self.presentViewController(alert, animated: true, completion: nil)
    }
            
    

    @IBAction func takePhotoButtonClicked(sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(.Camera)) {
            if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .Camera
                    self.imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(self.imagePicker, animated: true, completion: {})
                })
            } else {
                let alert = UIAlertController(title: nil, message: "Rear camera doesn't exist.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
                    alert2 in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    })
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
//            let alert = UIAlertController(title: nil, message: "Camera inaccessable.", preferredStyle: UIAlertControllerStyle.Alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) {
//                alert2 in
////                self.dismissViewControllerAnimated(true, completion: nil)
//                })
//            self.presentViewController(alert, animated: true, completion: nil)

            
                dispatch_async(dispatch_get_main_queue(), {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .PhotoLibrary
//                    self.imagePicker.cameraCaptureMode = .Photo
                    self.presentViewController(self.imagePicker, animated: true, completion: {
                    })
                })

            
        }
    }
    
    
    @IBAction func downloadButtonClicked(sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(SubcontractorDetailsViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    
    func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if error == nil {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Save error", message: error?.localizedDescription, preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        imagePicker.dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user saves an image
            dispatch_async(dispatch_get_main_queue(), {
                let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
                self.imageView.contentMode = .ScaleAspectFit //3
                self.imageView.image = chosenImage //4//        self.firstTimeLoaded = false
                
                
                self.subcontractor?.uploadCOI(chosenImage,
                    success: {
                        NSLog(".........................................success uploading")
//                        sleep(1)
//                        self.subcontractor?.downloadCOI({ (image) in
//                            self.imageView.image = image
//                            self.imageView.contentMode = .ScaleAspectFit
//                            }, failure: { (error) in
//                                print(error)
//                        })

                    }, failure: { (error) in
                        NSLog(".........................................error uploading")
                })
            })
        })
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("User canceled image")
        self.firstTimeLoaded = false
        dismissViewControllerAnimated(true, completion: {
            // Anything you want to happen when the user selects cancel
            
        })
    }
    
    let datePickerView:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    @IBAction func coiExpiresAtClicked(sender: UITextField) {
        datePickerView.datePickerMode = UIDatePickerMode.Date
        datePickerView.maximumDate = 10.years.fromNow
        datePickerView.minimumDate = NSDate()
        sender.inputView = datePickerView
        
        if(subcontractor?.coi_expires_at == nil) {
            subcontractor?.coi_expires_at = 1.years.fromNow
        }
        
        datePickerView.setDate((subcontractor?.coi_expires_at!)!, animated: false)
        datePickerView.addTarget(self, action: #selector(SubcontractorDetailsViewController.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        // Creates the toolbar
        toolBar.barStyle = .Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adds the buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: #selector(SubcontractorDetailsViewController.doneClicked))
        doneButton.setFAIcon(FAType.FAClose, iconSize: 20)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        // Adds the toolbar to the view
        coiExpiresAtField.inputView = datePickerView
        coiExpiresAtField.inputAccessoryView = toolBar
    }
    
    
    func doneClicked()
    {
//        print("done.................")
        datePickerView.removeFromSuperview()
        toolBar.removeFromSuperview()
        
        nameTextField.becomeFirstResponder()
        nameTextField.resignFirstResponder() // To resign the inputView on clicking done.
    }

    
    func datePickerValueChanged(sender:UIDatePicker) {
        let originalDate = self.subcontractor?.coi_expires_at!
        self.subcontractor?.coi_expires_at = sender.date
        
        self.subcontractor!.update({ () -> () in
            self.coiExpiresAtField.text = dateOnlyDateFormatter.stringFromDate(sender.date)
            },
                            failure: { (error) -> () in
                                let alert = UIAlertController(title: nil, message: "Unable to update date.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil)
                                self.subcontractor?.coi_expires_at = originalDate
            }
        )
        //        self.view.endEditing(true)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "SubcontractorActionCodesViewController") {
//            let destViewController = segue.destinationViewController as! SubcontractorActionCodesViewController
//            destViewController.Subcontractor = self.Subcontractor
//        }
//        
//        if (segue.identifier == "CheckinsViewController") {
//            _ = segue.destinationViewController as! CheckinsViewController
//            TLUser.setUserLogin()
//            TLSubcontractor.storeActivationCodeLocally((Subcontractor?.activationCode)!)
//        }
        
    }
    
}
