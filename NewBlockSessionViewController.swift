//
//  NewBlockSessionViewController.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/24/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka

class NewBlockSessionViewController: FormViewController {
    
    var blockSessionObj: BlockSession?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            Section()
            +++ Section()
            +++ Section()
            
            <<< PushRow<String>() {
                $0.tag = "dayPicker"
                $0.title = "Day"
                $0.options = ["Sunday", "Monday", "Tuesday", "Wednesday","Thursday", "Friday", "Saturday", "Everyday"]
                $0.selectorTitle = "Select Day"
                $0.value = "Monday"
            }
            
            <<< TimeInlineRow(){
                $0.tag = "startTime"
                $0.title = "Start Time"
                $0.value = NSDate()
            }
            
            <<< TimeInlineRow(){
                $0.tag = "endTime"
                $0.title = "End Time"
                $0.value = NSDate()
            }
    }
    
    
    @IBAction func onCancel(sender: UIBarButtonItem) {
//        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//        
//        if isPresentingInAddMealMode {
//            dismissViewControllerAnimated(true, completion: nil)
//        }
//        else {
//            navigationController!.popViewControllerAnimated(true)
//        }
        navigationController!.popViewControllerAnimated(true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/blocksessions"
        
        if saveButton === sender {
            
            let startTimeTextField = form.rowByTag("startTime")?.baseValue as! NSDate
            let endTimeTextField = form.rowByTag("endTime")?.baseValue as! NSDate
            let dayPickerValue = form.rowByTag("dayPicker")?.baseValue as! String
            
            let timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "HH:mm:ss"
            let startTimeValue = timeFormatter.stringFromDate(startTimeTextField)
            let endTimeValue = timeFormatter.stringFromDate(endTimeTextField)
            
            let blockSessionData: NSDictionary = [
                "start_time": startTimeValue,
                "end_time": endTimeValue,
                "day_of_week": dayPickerValue
            ]
            
            
            blockSessionObj = BlockSession(id: 1, startTime: startTimeValue, endTime: endTimeValue, selectedDay: dayPickerValue)
            
            let url = NSURL(string: postEndpoint)!
            let session = NSURLSession.sharedSession()
            let postParams : NSDictionary = blockSessionData
            
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
                    realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
                        print("Not a 200 response")
                        return
                }
                
                // Read the JSON
                if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    print("POST: Success" + postString)
                    
                }
                
            }).resume()
            
        }
    }
    
    
}
