//
//  NewGoal.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//


import Foundation

import UIKit

class SessionViewController: UIViewController, UINavigationControllerDelegate {
    
//    @IBOutlet weak var target_cal: UITextField!
//    
//    @IBOutlet weak var target_dis: UITextField!
//    @IBOutlet weak var nameTextField: UITextField!
//    
//    @IBOutlet weak var saveButton: UIBarButtonItem!
//    
//    @IBAction func cancel(sender: UIBarButtonItem) {
//        
//        let isPresentingInAddMealMode = presentingViewController is UINavigationController
//        
//        if isPresentingInAddMealMode {
//            dismissViewControllerAnimated(true, completion: nil)
//        }
//        else {
//            navigationController!.popViewControllerAnimated(true)
//        }
//        //dismissViewControllerAnimated(true, completion: nil)
//    }
//    
//    @IBOutlet weak var startGoalDate: UITextField!
//    
//    @IBOutlet weak var endGoalDate: UITextField!
//    
//    
//    @IBAction func startDateEditing(sender: UITextField) {
//        let datePickerView:UIDatePicker = UIDatePicker()
//        
//        datePickerView.datePickerMode = UIDatePickerMode.Date
//        
//        sender.inputView = datePickerView
//        
//        datePickerView.addTarget(self, action: #selector(NewGoal.startDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
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
//        datePickerView.addTarget(self, action: #selector(NewGoal.endDatePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
//    }
//    
//    var goal: Goal?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        if let goal = goal {
//            navigationItem.title = goal.name
//            nameTextField.text   = goal.name
//            target_cal.text = goal.target_burn_calories
//            target_dis.text = goal.target_distance
//            startGoalDate.text = goal.start_datetime
//            endGoalDate.text = goal.end_datetime
//            
//        }
//        checkValidGoalName()
//    }
//    
//    func checkValidGoalName() {
//        // Disable the Save button if the text field is empty.
//        let text = nameTextField.text ?? ""
//        saveButton.enabled = !text.isEmpty
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        checkValidGoalName()
//        self.view.endEditing(true)
//    }
//    
//    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        // Disable the Save button while editing.
//        saveButton.enabled = false
//    }
//    
//    func textFieldDidEndEditing(textField: UITextField) {
//        checkValidGoalName()
//        navigationItem.title = textField.text
//    }
//    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if saveButton === sender {
//            
//            let name = nameTextField.text ?? ""
//            
//            
//            // Set the goal to be passed to MealListTableViewController after the unwind segue
//            saveGoalEvent();
//        }
//    }
//    
//    
//    func startDatePickerValueChanged(sender:UIDatePicker) {
//        
//        let dateFormatter = NSDateFormatter()
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        
//        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        
//        startGoalDate.text = dateFormatter.stringFromDate(sender.date)
//        
//    }
//    
//    func endDatePickerValueChanged(sender:UIDatePicker) {
//        
//        let dateFormatter = NSDateFormatter()
//        
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        
//        dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
//        
//        endGoalDate.text = dateFormatter.stringFromDate(sender.date)
//        
//    }
//    
//    func saveGoalEvent(){
//        let localDB = NSUserDefaults.standardUserDefaults()
//        
//        let user_id = localDB.objectForKey("user_id")
//        
//        let name: String = nameTextField.text!
//        let target_burn_calories: String = target_cal.text!
//        let target_distance: String = target_dis.text!
//        let start_datetime: String = startGoalDate.text!
//        let end_datetime: String = endGoalDate.text!
//        
//        
//        let goalData: NSDictionary = [
//            "name": name,
//            "target_burn_calories": target_burn_calories,
//            "target_distance": target_distance,
//            "start_datetime": start_datetime,
//            "end_datetime": end_datetime,
//            ]
//        
//        localDB.setObject(goalData, forKey: "userGoalInfo")
//        
//        //var userGoalInfo = localDB.objectForKey("userBasicInfo") as! Dictionary<String, AnyObject>
//        //userGoalInfo.updateValue(goalData, forKey: "user_goals")
//        
//        let userGoalInfo = goalData
//        
//        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/test_user2/goals"
//        
//        let url = NSURL(string: postEndpoint)!
//        let session = NSURLSession.sharedSession()
//        let postParams : NSDictionary = userGoalInfo
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
//                realResponse.statusCode < 200 || realResponse.statusCode >= 300  else {
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
//        
//    }
    
    
}

