//
//  GoalViewController.swift
//  Example-Swift
//
//  Created by Saumil Dharia on 3/27/16.
//  Copyright © 2016 DC. All rights reserved.
//

import Foundation

import UIKit

class GoalViewController_old: UIViewController {
    
//    @IBOutlet weak var targetCal: UITextField!
//    @IBOutlet weak var startDate: UITextField!
//    @IBOutlet weak var endDate: UITextField!
//    
//    @IBOutlet weak var targetDistance_old: UITextField!
//    
//    @IBAction func startDateEditing(sender: UITextField) {
//        let datePickerView:UIDatePicker = UIDatePicker()
//        
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: #selector(GoalViewController_old.startDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
//        
//    }
//
//    @IBAction func endDateEditing(sender: UITextField) {
//        let datePickerView:UIDatePicker = UIDatePicker()
//        
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: #selector(GoalViewController_old.endDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
//    }
//    
//    @IBAction func createGoal(sender: UIButton) {
//        
//        /* REST: POST request for creating a new goal */
//        
//        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/jainil@vora.com/goals"
//        
//        let goalData: NSDictionary = ["target_burn_calories": 200,
//                                     "start_datetime": "2016-03-27",
//                                     "end_datetime": "2016-04-27"]
//        
//        let url = NSURL(string: postEndpoint)!
//        let session = NSURLSession.sharedSession()
//        let postParams : NSDictionary = goalData
//        
//        // Create the request
//        let request = NSMutableURLRequest(URL: url)
//        request.HTTPMethod = "POST"
//        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        do {
//            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
//            print(postParams)
//        } catch {
//            print("bad things happened")
//        }
//        
//        // Make the POST call and handle it in a completion handler
//        session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//            // Make sure we get an OK response
//            guard let realResponse = response as? NSHTTPURLResponse where
//                realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
//                    print("Not a 200 response")
//                    return
//            }
//            
//            // Read the JSON
//            if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
//                // Print what we got from the call
//                print("POST: " + postString)
//                
//            }
//            
//        }).resume()
//
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func startDatePickerValueChanged(sender:UIDatePicker) {
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let strDate = dateFormatter.stringFromDate(sender.date)
//        startDate.text = strDate
//        
//    }
//    
//    func endDatePickerValueChanged(sender:UIDatePicker) {
//        
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd"
//        let strDate = dateFormatter.stringFromDate(sender.date)
//        endDate.text = strDate
//    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        self.view.endEditing(true)
//    }

}