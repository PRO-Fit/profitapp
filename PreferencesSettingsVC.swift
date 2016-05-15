//
//  PreferencesSettingsVC.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/22/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka
import SwiftValidator

class PreferencesSettingsVC: FormViewController {
    
    var userPreferencesData: NSDictionary = [:]
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            Section()
            +++ Section()
            +++ Section("Set Preferences")
            
            <<< StepperRow() {
                $0.tag = "runningPrefValue"
                $0.title = "Running"
                $0.value = userPreferencesData["run"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "walkingPrefValue"
                $0.title = "Walking"
                $0.value = userPreferencesData["walk"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "joggingPrefValue"
                $0.title = "Jogging"
                $0.value = userPreferencesData["jog"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "dancingPrefValue"
                $0.title = "Dancing"
                $0.value = userPreferencesData["dance"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "bikingPrefValue"
                $0.title = "Biking"
                $0.value = userPreferencesData["bike"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "hikingPrefValue"
                $0.title = "Hiking"
                $0.value = userPreferencesData["hike"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "gymPrefValue"
                $0.title = "Gym"
                $0.value = userPreferencesData["gym"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "swimmingPrefValue"
                $0.title = "Swimmming"
                $0.value = userPreferencesData["swim"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "sportsPrefValue"
                $0.title = "Sports"
                $0.value = userPreferencesData["sport"] as? Int
            }
            <<< StepperRow() {
                $0.tag = "yogaPrefValue"
                $0.title = "Yoga"
                $0.value = userPreferencesData["yoga"] as? Int
            }
            
            <<< StepperRow() {
                $0.tag = "aerobicsPrefValue"
                $0.title = "Aerobics"
                $0.value = userPreferencesData["aerobic"] as? Int
            }
            
            +++ Section()
        
    }
    
    @IBAction func unwindPreferencesToSettingsHome(sender: UIStoryboardSegue) {
        
        
    }

    @IBAction func onUpdateClickHandler(sender: UIBarButtonItem) {
        let runningPrefValue = form.rowByTag("runningPrefValue")!.baseValue as! Int
        let joggingPrefValue = form.rowByTag("joggingPrefValue")!.baseValue as! Int
        let walkingPrefValue = form.rowByTag("walkingPrefValue")!.baseValue as! Int
        let bikingPrefValue = form.rowByTag("bikingPrefValue")!.baseValue as! Int
        let gymPrefValue = form.rowByTag("gymPrefValue")!.baseValue as! Int
        let sportsPrefValue = form.rowByTag("sportsPrefValue")!.baseValue as! Int
        let hikingPrefValue = form.rowByTag("hikingPrefValue")!.baseValue as! Int
        let aerobicsPrefValue = form.rowByTag("aerobicsPrefValue")!.baseValue as! Int
        let dancingPrefValue = form.rowByTag("dancingPrefValue")!.baseValue as! Int
        let yogaPrefValue = form.rowByTag("yogaPrefValue")!.baseValue as! Int
        let swimmingPrefValue = form.rowByTag("swimmingPrefValue")!.baseValue as! Int
        
        let preferences: NSDictionary = [
            "run": runningPrefValue,
            "jog": joggingPrefValue,
            "walk": walkingPrefValue,
            "bike": bikingPrefValue,
            "gym": gymPrefValue,
            "sport": sportsPrefValue,
            "hike": hikingPrefValue,
            "aerobic": aerobicsPrefValue,
            "dance": dancingPrefValue,
            "yoga": yogaPrefValue,
            "swim": swimmingPrefValue
        ]
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id = localDB.objectForKey("user_email") as! String
        
        let putEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/preferences"
        
        let url = NSURL(string: putEndpoint)!
        let session = NSURLSession.sharedSession()
        let putParams : NSDictionary = preferences
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(putParams, options: NSJSONWritingOptions())
            print(putParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the PUT call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let putString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("PUT Success" + putString)
                
            }
            
        }).resume()
        navigationController!.popViewControllerAnimated(true)

        
    }
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
}
