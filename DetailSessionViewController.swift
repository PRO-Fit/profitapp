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

class DetailSessionViewController: FormViewController {
    
    var sessionName: String = ""
    var startDate: String = ""
    var endDate: String = ""
    var sessionFeedbackId: String = ""
    var sessionStatus: String = ""
    var sessionObj :Session?
    var workOutTypeIdMap = [Int: String]()
    
    @IBOutlet weak var updateSession: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.workOutTypeIdMap[1] = "Walking"
        self.workOutTypeIdMap[2] = "Jogging"
        self.workOutTypeIdMap[3] = "Standing"
        self.workOutTypeIdMap[4] = "Sitting"
        self.workOutTypeIdMap[5] = "Up"
        self.workOutTypeIdMap[6] = "Down"
        self.workOutTypeIdMap[7] = "Running"
        self.workOutTypeIdMap[8] = "Biking"
        self.workOutTypeIdMap[9] = "Gym"
        self.workOutTypeIdMap[10] = "Sports"
        self.workOutTypeIdMap[11] = "Hiking"
        self.workOutTypeIdMap[12] = "Aerobics"
        self.workOutTypeIdMap[13] = "Dancing"
        self.workOutTypeIdMap[14] = "Yoga"
        self.workOutTypeIdMap[15] = "Swimming"
        
        form = Section()
            
            +++ Section()
            +++ Section("Session")
            
            <<< SVTextRow() {
                $0.tag = "sessionName"
                $0.title =  "Name"
                $0.value = sessionObj?.sessionName
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
            }
            //                .onChange({ (row) in
            //                    self.sessionName = row.value!
            //                })
            
            <<< PushRow<String>() {
                $0.title = "Workout Type"
                $0.tag = "workoutTypePicker"
                $0.options = ["Walking","Running","Jogging","Gym","Hiking","Biking","Sports","Dancing","Swimming", "Aerobics"]
                //$0.value = "Jogging"
                $0.selectorTitle = "Choose your workout type"
                let id : Int = sessionObj!.workout_type_id
                $0.value = self.workOutTypeIdMap[id]!
                
                }  .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            //                .onChange({ (row) in
            //                    //self.workoutType = row.value!
            //                })
            
            
            <<< NameRow() {
                $0.tag = "sessionFeedbackId"
                $0.hidden = true
                
            }
            //                .onChange({ (row) in
            //                    self.sessionFeedbackId = row.value!
            //                })
            
            <<< DateTimeInlineRow("Starts") {
                $0.title = "Starts"
                let sessionStartTime = sessionObj?.start_datetime
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let startDateFormat = dateFormatter.dateFromString(sessionStartTime!)
                $0.value = startDateFormat
                }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            
            //                .onChange { [weak self] row in
            //                    let endRow: DateTimeInlineRow! = self?.form.rowByTag("Ends")
            //                    if row.value?.compare(endRow.value!) == .OrderedDescending {
            //                        endRow.value = NSDate(timeInterval: 60*60*24, sinceDate: row.value!)
            //                        endRow.cell!.backgroundColor = .whiteColor()
            //                        endRow.updateCell()
            //                    }
            //                    self!.startDate = (row.value?.description)!
            //            }
            
            <<< DateTimeInlineRow("Ends"){
                $0.title = "Ends"
                
                let sessionEndTime = sessionObj?.end_datetime
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let endDateFormat = dateFormatter.dateFromString(sessionEndTime!)
                $0.value = endDateFormat
                }
                
                //                $0.value = NSDate().dateByAddingTimeInterval(60*60*25)
                //                }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            //                .onChange { [weak self] row in
            //                    let startRow: DateTimeInlineRow! = self?.form.rowByTag("Starts")
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
            
            <<< NameRow() {
                $0.tag = "sessionStatus"
                $0.title =  "Session Status"
                $0.hidden = true
        }
        //                .onChange({ (row) in
        //                    self.sessionStatus = row.value!
        //                })
        //            +++ Section("Match on the go")
        //
        //            <<< NameRow() {
        //                $0.tag = "friendToJoin"
        //                $0.title =  "Workout Buddy"
        //                $0.value = "Jvalant Patel"
        //                }.cellUpdate { cell, row in
        //                    cell.textLabel?.textColor = UIColor.blueColor()
        //        }
        
        
    }
    
    
    
//    @IBAction func onUpdateClickHandler(sender: UIBarButtonItem) {
//        var workoutTypeId: String = ""
//        let workoutTypeSelected: String = form.rowByTag("workoutTypePicker")?.baseValue as! String
//        
//        switch workoutTypeSelected {
//        case "Walking":
//            workoutTypeId = "1"
//        case "Jogging":
//            workoutTypeId = "2"
//        case "Running":
//            workoutTypeId = "7"
//        case "Biking":
//            workoutTypeId = "8"
//        case "Gym":
//            workoutTypeId = "9"
//        case "Sports":
//            workoutTypeId = "10"
//        case "Hiking":
//            workoutTypeId = "11"
//        case "Aerobics":
//            workoutTypeId = "12"
//        case "Dancing":
//            workoutTypeId = "13"
//        case "Swimming":
//            workoutTypeId = "15"
//            
//        default:
//            workoutTypeId = "1"
//        }
//        
//        var sessionNameValue: String = form.rowByTag("sessionName")?.baseValue as? String ?? ""
//        sessionNameValue = sessionNameValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
//        let dataValid = form.validateAll()
//        
//        if (updateSession === sender && dataValid && sessionNameValue != "") {
//            
//            let dateFormatter = NSDateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let startDateVal = form.rowByTag("Starts")?.baseValue as! NSDate
//            let endsDateVal = form.rowByTag("Ends")?.baseValue as! NSDate
//            let startsValue = dateFormatter.stringFromDate(startDateVal)
//            let endsValue = dateFormatter.stringFromDate(endsDateVal)
//            
//            sessionObj!.sessionName = form.rowByTag("sessionName")?.baseValue as! String
//            sessionObj!.workout_type_id = Int(workoutTypeId)!
//            sessionObj!.start_datetime = startsValue
//            sessionObj!.end_datetime = endsValue
//            
//            let localDB = NSUserDefaults.standardUserDefaults()
//            let user_id: String = localDB.objectForKey("user_email") as! String
//            
//            let startDateValue = form.rowByTag("Starts")?.baseValue as! NSDate
//            let endDateValue = form.rowByTag("Ends")?.baseValue as! NSDate
//            let name: String = form.rowByTag("sessionName")?.baseValue as! String
//            
//            let startDateString = dateFormatter.stringFromDate(startDateValue)
//            let endDateString = dateFormatter.stringFromDate(endDateValue)
//            
//            let sessionData: NSDictionary = ["name": name,"user_id": user_id, "workout_type_id": workoutTypeId, "start_datetime": startDateString, "end_datetime": endDateString, "session_feedback_id": "1", "session_status": "USER_CREATED"]
//            
//            
//            let putEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/sessions/" + (sessionObj?.id)!
//            print(putEndpoint)
//            
//            let url = NSURL(string: putEndpoint)!
//            let session = NSURLSession.sharedSession()
//            let putParams : NSDictionary = sessionData
//            
//            // Create the request
//            let request = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "PUT"
//            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//            do {
//                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(putParams, options: NSJSONWritingOptions())
//                print(putParams)
//            } catch {
//                print("bad things happened")
//            }
//            
//            // Make the PUT call and handle it in a completion handler
//            session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
//                // Make sure we get an OK response
//                guard let realResponse = response as? NSHTTPURLResponse where
//                    realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
//                        print("Not a 200 response")
//                        return
//                }
//                
//                // Read the JSON
//                if let putString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
//                    // Print what we got from the call
//                    print("PUT Success" + putString)
//                    
//                }
//                
//            }).resume()
//            
//            navigationController!.popViewControllerAnimated(true)
//            
//        }
//       
//
//        
//        
//    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        var sessionNameValue: String = form.rowByTag("sessionName")?.baseValue as? String ?? ""
        sessionNameValue = sessionNameValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let dataValid = form.validateAll()
        
        if (updateSession === sender && dataValid && sessionNameValue != "") {
            
            var workoutTypeId: String = ""
            let workoutTypeSelected: String = form.rowByTag("workoutTypePicker")?.baseValue as! String
            
            switch workoutTypeSelected {
            case "Walking":
                workoutTypeId = "1"
            case "Jogging":
                workoutTypeId = "2"
            case "Running":
                workoutTypeId = "7"
            case "Biking":
                workoutTypeId = "8"
            case "Gym":
                workoutTypeId = "9"
            case "Sports":
                workoutTypeId = "10"
            case "Hiking":
                workoutTypeId = "11"
            case "Aerobics":
                workoutTypeId = "12"
            case "Dancing":
                workoutTypeId = "13"
            case "Swimming":
                workoutTypeId = "15"
                
            default:
                workoutTypeId = "1"
            }
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let startDateVal = form.rowByTag("Starts")?.baseValue as! NSDate
            let endsDateVal = form.rowByTag("Ends")?.baseValue as! NSDate
            let startsValue = dateFormatter.stringFromDate(startDateVal)
            let endsValue = dateFormatter.stringFromDate(endsDateVal)
            
            sessionObj!.sessionName = form.rowByTag("sessionName")?.baseValue as! String
            sessionObj!.workout_type_id = Int(workoutTypeId)!
            sessionObj!.start_datetime = startsValue
            sessionObj!.end_datetime = endsValue
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            
            let startDateValue = form.rowByTag("Starts")?.baseValue as! NSDate
            let endDateValue = form.rowByTag("Ends")?.baseValue as! NSDate
            let name: String = form.rowByTag("sessionName")?.baseValue as! String
            
            let startDateString = dateFormatter.stringFromDate(startDateValue)
            let endDateString = dateFormatter.stringFromDate(endDateValue)
            
            let sessionData: NSDictionary = ["name": name,"user_id": user_id, "workout_type_id": workoutTypeId, "start_datetime": startDateString, "end_datetime": endDateString, "session_feedback_id": "1", "session_status": "USER_CREATED"]
            
            
            let putEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/sessions/" + (sessionObj?.id)!
            print(putEndpoint)
            
            let url = NSURL(string: putEndpoint)!
            let session = NSURLSession.sharedSession()
            let putParams : NSDictionary = sessionData
            
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
            
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        /* REST: POST request for creating a new goal */
//        
//        
//    }
    
    
    
    
}
