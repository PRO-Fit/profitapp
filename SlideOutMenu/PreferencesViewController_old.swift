//
//  PreferencesViewController.swift
//  SlideOutMenu
//
//  Created by Vijesh Jain on 3/20/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import Foundation


class PreferencesViewController_old: UIViewController  {

    @IBOutlet weak var swimmingSliderText: UILabel!
    @IBOutlet weak var joggingSliderText: UILabel!
    @IBOutlet weak var walkingSliderText: UILabel!
    @IBOutlet weak var runningSliderText: UILabel!
    @IBOutlet weak var bikingSliderText: UILabel!
    @IBOutlet weak var gymSliderText: UILabel!
    @IBOutlet weak var hikingSliderText: UILabel!
    @IBOutlet weak var sportsSliderText: UILabel!
    @IBOutlet weak var danceSliderText: UILabel!
    @IBOutlet weak var yogaSliderText: UILabel!
    @IBOutlet weak var aerobicsSliderText: UILabel!
    
    var walkingPrefValue: Int = 1
    var runningPrefValue: Int = 1
    var joggingPrefValue: Int = 1
    var swimmingPrefValue: Int = 1
    var bikingPrefValue: Int = 1
    var gymPrefValue: Int = 1
    var hikingPrefValue: Int = 1
    var sportsPrefValue: Int = 1
    var dancePrefValue: Int = 1
    var yogaPrefValue: Int = 1
    var aerobicsPrefValue: Int = 1
    

    @IBAction func walkingSliderHandler(sender: UISlider) {
        walkingPrefValue = Int(sender.value)
        walkingSliderText.text = "\(walkingPrefValue)"
    }
    @IBAction func runningSliderHandler(sender: UISlider) {
        runningPrefValue = Int(sender.value)
        runningSliderText.text = "\(runningPrefValue)"
    }
    @IBAction func joggingSliderHandler(sender: UISlider) {
        joggingPrefValue = Int(sender.value)
        joggingSliderText.text = "\(joggingPrefValue)"
    }
    @IBAction func swimmingSliderHandler(sender: UISlider) {
        swimmingPrefValue = Int(sender.value)
        swimmingSliderText.text = "\(swimmingPrefValue)"
    }
    @IBAction func bikingSliderHandler(sender: UISlider) {
        bikingPrefValue = Int(sender.value)
        bikingSliderText.text = "\(bikingPrefValue)"
    }
    @IBAction func gymSliderHandler(sender: UISlider) {
        gymPrefValue = Int(sender.value)
        gymSliderText.text = "\(gymPrefValue)"
    }
    
    @IBAction func hikingSliderHandler(sender: UISlider) {
        hikingPrefValue = Int(sender.value)
        hikingSliderText.text = "\(hikingPrefValue)"
    }
    
    @IBAction func sportsSliderHandler(sender: UISlider) {
        sportsPrefValue = Int(sender.value)
        sportsSliderText.text = "\(sportsPrefValue)"
    }
    
    @IBAction func danceSliderHandler(sender: UISlider) {
        dancePrefValue = Int(sender.value)
        danceSliderText.text = "\(dancePrefValue)"
    }
    @IBAction func aerobicsSliderHandler(sender: UISlider) {
        aerobicsPrefValue = Int(sender.value)
        aerobicsSliderText.text = "\(aerobicsPrefValue)"
    }
    @IBAction func yogaSliderHandler(sender: UISlider) {
        yogaPrefValue = Int(sender.value)
        yogaSliderText.text = "\(yogaPrefValue)"
    }

    @IBAction func onClickSubmit(sender: AnyObject) {
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
            "dance": dancePrefValue,
            "yoga": yogaPrefValue,
            "swim": swimmingPrefValue
        ]
        var userInfo = localDB.objectForKey("userBasicInfo") as! Dictionary<String, AnyObject>
        userInfo.updateValue(preferences, forKey: "activity_preferences")

        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users"

        let url = NSURL(string: postEndpoint)!
        let session = NSURLSession.sharedSession()
        let postParams : NSDictionary = userInfo

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
                realResponse.statusCode == 200 else {
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
    
    override func viewDidLoad() {
        
        walkingSliderText.text = "\(walkingPrefValue)"
        runningSliderText.text = "\(runningPrefValue)"
        walkingSliderText.text = "\(walkingPrefValue)"
        joggingSliderText.text = "\(joggingPrefValue)"
        swimmingSliderText.text = "\(swimmingPrefValue)"
        bikingSliderText.text = "\(bikingPrefValue)"
        gymSliderText.text = "\(gymPrefValue)"
        hikingSliderText.text = "\(hikingPrefValue)"
        sportsSliderText.text = "\(sportsPrefValue)"
        danceSliderText.text = "\(dancePrefValue)"
        yogaSliderText.text = "\(yogaPrefValue)"
        aerobicsSliderText.text = "\(aerobicsPrefValue)"
        
        super.viewDidLoad()
    }
}
