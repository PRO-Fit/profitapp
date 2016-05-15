//
//  GoalsViewController.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/13/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka
import SwiftValidator

class GoalDetailViewController: FormViewController {
    
    var goalName: String = ""
    var targetCal: Int = 0
    var targetDistance: Int = 0
    var startDate: String = ""
    var endDate: String = ""
    var goal: Goal?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form = Section()
            
            +++ Section()
            +++ Section("Create a Goal Target")
            
            <<< SVTextRow() {
                $0.tag = "goalName"
                $0.title =  "Goal Name"
                $0.placeholder = "(e.g. Lose belly fat)"
                $0.value = goal?.name
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
                }
//                .onChange({ (row) in
//                    self.goalName = row.value!
//                })
            
            <<< SVIntRow() {
                $0.tag = "targetCalories"
                $0.title = "Calories to be burned"
                $0.placeholder = "(e.g. 300)"
                $0.value = goal?.target_burn_calories
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
                }
//                .onChange({ (row) in
//                    self.targetCal = row.value!
//                })
            
            <<< SVIntRow() {
                $0.tag = "targetDistance"
                $0.title = "Distance to be covered"
                $0.placeholder = "(e.g. 400)"
                $0.value = goal?.target_distance
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
                }
//                .onChange({ (row) in
//                    self.targetDistance = row.value!
//                })
            
            <<< DateTimeInlineRow("Start Date") {
                $0.title = "Start Date"
                $0.tag = "startDate"
                let goalStartTime = goal?.start_datetime
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let startDateFormat = dateFormatter.dateFromString(goalStartTime!)
                $0.value = startDateFormat
                
                }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            
            
            //                .onChange { [weak self] row in
            //                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("endDate")
            //                    if row.value?.compare(endRow.value!) == .OrderedDescending {
            //                        endRow.value = NSDate()
            //                        endRow.cell!.backgroundColor = .whiteColor()
            //                        endRow.updateCell()
            //                    }
            //                    self!.startDate = (row.value?.description)!
            //            }
            
            <<< DateTimeInlineRow("End Date"){
                $0.tag = "endDate"
                $0.title = "End Date"
                let goalEndTime = goal?.end_datetime
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let endDateFormat = dateFormatter.dateFromString(goalEndTime!)
                $0.value = endDateFormat
        }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
        }
        //                .cellUpdate { cell, row in
        //                    cell.detailTextLabel?.textColor = UIColor.blackColor()
        //                    if self.endDate == self.endDate {
        //                        self.endDate = (cell.detailTextLabel?.text)!
        //                    }
        //                }
        //                .onChange { [weak self] row in
        //                    let startRow: DateTimeInlineRow! = self?.form.rowByTag("startDate")
        //                    if row.value?.compare(startRow.value!) == .OrderedAscending {
        //                        row.cell!.backgroundColor = .redColor()
        //                    }
        //                    else{
        //                        row.cell!.backgroundColor = .whiteColor()
        //                        self!.endDate = (row.value?.description)!
        //
        //                    }
        //                    row.updateCell()
        //            }
        
        
        //+++ Section()
        
        
        //        if let goal = goal {
        //            navigationItem.title = goal.name
        //            form.rowByTag("goalName")?.baseValue = goal.name
        //            form.rowByTag("targetCalories")?.baseValue = goal.target_burn_calories
        //            form.rowByTag("targetDistance")?.baseValue  = goal.target_distance
        //            form.rowByTag("startDate")?.baseValue = goal.start_datetime
        //            form.rowByTag("endDate")?.baseValue = goal.end_datetime
        //
        //        }
        //checkValidGoalName()   // TODO: Not working, beacuse of null values onChange
        
        
        
    }
    
    
    func checkValidGoalName() {
        // Disable the Save button if the text field is empty.
        let text: String = form.rowByTag("goalName")?.baseValue as! String
        saveButton.enabled = !text.isEmpty
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        /* REST: POST request for creating a new goal */
//        if saveButton === sender {
//            
//            let localDB = NSUserDefaults.standardUserDefaults()
//            let user_id: String = localDB.objectForKey("user_email") as! String
//            let goal_id: String = (goal?.id)!
//            let goalName = form.rowByTag("goalName")?.baseValue as! String
//            let targCal = form.rowByTag("targetCalories")?.baseValue as! Int
//            let targDis = form.rowByTag("targetDistance")?.baseValue as! Int
//            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let startDateVal = form.rowByTag("startDate")?.baseValue as! NSDate
//            let endsDateVal = form.rowByTag("endDate")?.baseValue as! NSDate
//            let startsValue = dateFormatter.stringFromDate(startDateVal)
//            let endsValue = dateFormatter.stringFromDate(endsDateVal)
//            
//            
//            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/goals/" + goal_id
//            
//            if saveButton === sender {
//                
//                let goalData: NSDictionary = ["name": goalName,
//                                              "target_burn_calories": targCal,
//                                              "target_distance": targDis,
//                                              "start_datetime": startsValue,
//                                              "end_datetime": endsValue]
//                
//                
//                goal = Goal(name: goalName, end_datetime: endsValue, start_datetime: startsValue, id: (goal?.id)!, target_burn_calories: targCal, target_distance: targDis, user_id: user_id)
//                
//                let url = NSURL(string: postEndpoint)!
//                let session = NSURLSession.sharedSession()
//                let putParams : NSDictionary = goalData
//                
//                // Create the request
//                let request = NSMutableURLRequest(URL: url)
//                request.HTTPMethod = "PUT"
//                request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//                do {
//                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(putParams, options: NSJSONWritingOptions())
//                    print(putParams)
//                } catch {
//                    print("bad things happened")
//                }
//                
//                // Make the POST call and handle it in a completion handler
//                session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                    // Make sure we get an OK response
//                    guard let realResponse = response as? NSHTTPURLResponse where
//                        realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
//                            print("Not a 200 response")
//                            return
//                    }
//                    
//                    // Read the JSON
//                    if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
//                        // Print what we got from the call
//                        print("PUT: " + postString)
//                        
//                    }
//                    
//                }).resume()
//                
//            }
//        }
        
        
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        
        if(cancelButton === sender){
            navigationController!.popViewControllerAnimated(true)
        }
        
        var goalNameValue: String = form.rowByTag("goalName")?.baseValue as? String ?? ""
        goalNameValue = goalNameValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let dataValid = form.validateAll()
        
        if (saveButton === sender && dataValid && goalNameValue != "") {
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            let goal_id: String = (goal?.id)!
            let goalName = form.rowByTag("goalName")?.baseValue as! String
            let targCal = form.rowByTag("targetCalories")?.baseValue as! Int
            let targDis = form.rowByTag("targetDistance")?.baseValue as! Int
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDateVal = form.rowByTag("startDate")?.baseValue as! NSDate
            let endsDateVal = form.rowByTag("endDate")?.baseValue as! NSDate
            let startsValue = dateFormatter.stringFromDate(startDateVal)
            let endsValue = dateFormatter.stringFromDate(endsDateVal)
            
            
            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/goals/" + goal_id
            
            if saveButton === sender {
                
                let goalData: NSDictionary = ["name": goalName,
                                              "target_burn_calories": targCal,
                                              "target_distance": targDis,
                                              "start_datetime": startsValue,
                                              "end_datetime": endsValue]
                
                
                goal = Goal(name: goalName, end_datetime: endsValue, start_datetime: startsValue, id: (goal?.id)!, target_burn_calories: targCal, target_distance: targDis, user_id: user_id)
                
                let url = NSURL(string: postEndpoint)!
                let session = NSURLSession.sharedSession()
                let putParams : NSDictionary = goalData
                
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
                        print("PUT: Success" + postString)
                        
                    }
                    
                }).resume()
                
            }
            return true
        }
        
        return false
    }
    
    
    
    
}
