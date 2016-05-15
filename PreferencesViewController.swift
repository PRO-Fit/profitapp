//
//  PreferencesViewController1.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/13/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka

class PreferencesViewController: FormViewController {
    
    var walkingPrefValue: Int = 1
    var runningPrefValue: Int = 1
    var joggingPrefValue: Int = 1
    var swimmingPrefValue: Int = 1
    var bikingPrefValue: Int = 1
    var gymPrefValue: Int = 1
    var hikingPrefValue: Int = 1
    var sportsPrefValue: Int = 1
    var dancingPrefValue: Int = 1
    var yogaPrefValue: Int = 1
    var aerobicsPrefValue: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            Section()
            
            +++ Section("Set Preferences")
            
            <<< StepperRow() {
                $0.tag = "runningPrefValue"
                $0.title = "Running"
                $0.value = 1
                }.onChange({ (row) in
                    self.runningPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "walkingPrefValue"
                $0.title = "Walking"
                $0.value = 1
                }.onChange({ (row) in
                    self.walkingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "joggingPrefValue"
                $0.title = "Jogging"
                $0.value = 1
                }.onChange({ (row) in
                    self.joggingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "dancingPrefValue"
                $0.title = "Dancing"
                $0.value = 1
                }.onChange({ (row) in
                    self.dancingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "bikingPrefValue"
                $0.title = "Biking"
                $0.value = 1
                }.onChange({ (row) in
                    self.bikingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "hikingPrefValue"
                $0.title = "Hiking"
                $0.value = 1
                }.onChange({ (row) in
                    self.hikingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "gymPrefValue"
                $0.title = "Gym"
                $0.value = 1
                }.onChange({ (row) in
                    self.gymPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "swimmingPrefValue"
                $0.title = "Swimmming"
                $0.value = 1
                }.onChange({ (row) in
                    self.swimmingPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "sportsPrefValue"
                $0.title = "Sports"
                $0.value = 1
                }.onChange({ (row) in
                    self.sportsPrefValue = Int(row.value!)
                })
            <<< StepperRow() {
                $0.tag = "yogaPrefValue"
                $0.title = "Yoga"
                $0.value = 1
                }.onChange({ (row) in
                    self.yogaPrefValue = Int(row.value!)
                })
            
            <<< StepperRow() {
                $0.tag = "aerobicsPrefValue"
                $0.title = "Aerobics"
                $0.value = 1
                }.onChange({ (row) in
                    self.aerobicsPrefValue = Int(row.value!)
                })
            
            
            +++ Section()
            <<< ButtonRow("btnSubmit") {
                $0.tag = "btnSubmit"
                $0.title = "Go to Dashboard"
                $0.presentationMode = .SegueName(segueName: "showDashboardSegue", completionCallback: nil )
                } .cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.blueColor()
        }
        
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let localDB = NSUserDefaults.standardUserDefaults()
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
        
        var userData = localDB.objectForKey("userBasicInfo") as! Dictionary<String, AnyObject>
        userData.updateValue(preferences, forKey: "activity_preferences")
        
        localDB.setObject(userData, forKey: "userData")
        
        
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users"
        
        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : NSDictionary = userData
        
        // Create the request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
            print(postParams)
        } catch {
            print("bad things happened")
        }
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300  else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                // Print what we got from the call
                print("POST: " + postString)
                
            }
            
        }).resume()
        
    }
    
}
