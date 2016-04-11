//
//  AppDelegate.swift
//  TLog
//
//  Created by D on 2/15/16.
//  Copyright © 2016 EchoWaves. All rights reserved.
//

import UIKit


let TL_HOST = "http://localhost:3000"
//let TL_HOST = "http://192.168.1.145:3000"
//let TL_HOST = "http://172.20.10.2:3000"
//let TL_HOST = "http://tlog.us:3000"

let defaultDateFormatter = NSDateFormatter()


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        defaultDateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        defaultDateFormatter.timeStyle = .ShortStyle

        // Override point for customization after application launch.
        Localytics.autoIntegrate("32d519b62a1d7a231f5e8e2-3de491f8-d3f7-11e5-09e8-00cef1388a40", launchOptions: launchOptions)
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //handling deeplinking
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        NSLog("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< url: \(url.description)")
        
        //lets parse query string params and extract token
        let params = NSMutableDictionary()
        for param in url.query!.componentsSeparatedByString("&") {
            let elts = param.componentsSeparatedByString("=")
            if elts.count < 2 {
                continue
            }
            params.setObject(elts[1], forKey: elts[0])
        }
        
        TLEmployee.storeActivationCodeLocally(params.valueForKey("activation_code") as! String)
        
        
        if(TLEmployee.retreiveActivationCodeFromLocalStorage() != nil) {
            let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let employeeHomeViewController : UIViewController = mainStoryboardIpad.instantiateViewControllerWithIdentifier("EmployeeHomeViewController") as UIViewController
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            self.window?.rootViewController = employeeHomeViewController
            self.window?.makeKeyAndVisible()
        }
        
        return true
    }
    
}


func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
    return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
}


//http://www.absoluteripple.com/resources/using-ios-storyboard-segues
//https://start.branch.io  deeplinking
//http://stackoverflow.com/questions/24825123/get-the-current-view-controller-from-the-app-delegate