//
//  ViewController.swift
//  Example-Swift
//
//  Created by Paul on 6/1/15.
//  Copyright (c) 2015 DC. All rights reserved.
//

import UIKit
import Charts
import Social
import AdSupport
import ChameleonFramework

class NavigatorViewController: UIViewController, DCPathButtonDelegate {
    
    var dcPathButton:DCPathButton!
    var goals = [Goal]()
    var blockSessions = [BlockSession]()
    var userSessionsCount = [String: Int]()
    //var userSessions = [String: [Session]]()
    var sessions = [Session]()
    var notifications = [Notification]()
    var userSessions = Dictionary<String, Array<Session>>()
    var days: [String]!
    var months: [String]!
    var hours: [String]!
    var distanceCoveredInHours: [Double]!
    var distanceCoveredInWeekDays: [Double]!
    var distanceCoveredInMonths: [Double]!
    
    var caloriesBurntInHours: [Double]!
    var caloriesBurntInWeekDays: [Double]!
    var caloriesBurntInMonths: [Double]!
    
    var totalDisInHR: Double = 0.0
    var totalDisInDay: Double = 0.0
    var totalDisInMonth: Double = 0.0
    var totalCalInHR: Double = 0.0
    var totalCalInDay: Double = 0.0
    var totalCalInMonth: Double = 0.0
    
    
    var dayCalories:[Double]!
    var dayDistances:[Double]!
    var dayHours:[String]!
    
    var weekCalories:[Double]!
    var weekDistances :[Double]!
    var weekDays:[String]!
    
    var monthCalories: [Double]!
    var monthDistances:[Double]!
    var monthDates:[String]!
    
    var notification:UILocalNotification!
    
    var todaysDate: String = ""
    
    
    
    @IBOutlet weak var hoursLineChart: LineChartView!
    
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var displaySegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var totalDistance: UILabel!
    
    @IBOutlet weak var totalCalories: UILabel!
    
    @IBAction func distanceGraphSelector(sender: UISegmentedControl) {
        switch displaySegmentedControl.selectedSegmentIndex {
        case 0:
            setLineChart(hours, values: distanceCoveredInHours, xValues: hours)
            setBarChart(hours, values: distanceCoveredInHours, xValues: hours)
            totalDistance.text = String(totalDisInHR) + " km"
            totalCalories.text = String(totalCalInHR) + " cal"
        case 1:
            setLineChart(days, values: distanceCoveredInWeekDays, xValues: days)
            setBarChart(days, values: distanceCoveredInWeekDays, xValues: days)
            totalDistance.text = String(totalDisInDay) + " km"
            totalCalories.text = String(totalCalInDay) + " cal"
        case 2:
            setLineChart(months, values: distanceCoveredInMonths, xValues: months)
            setBarChart(months, values: distanceCoveredInMonths, xValues: months)
            totalDistance.text = String(totalDisInMonth) + " km"
            totalCalories.text = String(totalCalInMonth) + " cal"
        default:
            break;
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        

        
        getUserAnalyticsTest()
        
        //        getUserSessions()
        //        getBlockedSessions()
        //getNotifications()
        configureDCPathButton()
        
        hours = dayHours
        distanceCoveredInHours = dayDistances
        
        for dis in distanceCoveredInHours {
            totalDisInHR = totalDisInHR + dis
        }
        
        totalDisInHR = Double(round(1000*totalDisInHR)/1000)
        
        caloriesBurntInHours = dayCalories
        
        for cal in caloriesBurntInHours {
            totalCalInHR = totalCalInHR + cal
        }
        
        totalCalInHR = Double(round(1000*totalCalInHR)/1000)
        
        days = weekDays
        distanceCoveredInWeekDays = weekDistances
        
        for dis in distanceCoveredInWeekDays {
            totalDisInDay = totalDisInDay + dis
        }
        
        totalDisInDay = Double(round(1000*totalDisInDay)/1000)
        
        caloriesBurntInWeekDays = weekCalories
        
        for cal in caloriesBurntInWeekDays {
            totalCalInDay = totalCalInDay + cal
        }
        
        totalCalInDay = Double(round(1000*totalCalInDay)/1000)
        
        months = monthDates
        distanceCoveredInMonths = monthDistances
        
        for dis in distanceCoveredInMonths {
            totalDisInMonth = totalDisInMonth + dis
        }
        
        totalDisInMonth = Double(round(1000*totalDisInMonth)/1000)
        
        caloriesBurntInMonths = monthCalories
        
        for cal in caloriesBurntInMonths {
            totalCalInMonth = totalCalInMonth + cal
        }
        
        totalCalInMonth = Double(round(1000*totalCalInMonth)/1000)
        
        setLineChart(hours, values: distanceCoveredInHours, xValues: hours)
        totalDistance.text = String(totalDisInHR) + " km"
        
        setBarChart(hours, values: caloriesBurntInHours, xValues: hours)
        totalCalories.text = String(totalCalInHR) + " cal"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getNotifications()
        getUserSessions()
        getBlockedSessions()
        getUserGoals()
        getTodaysSession()
        
        if(!todaysDate.isEmpty){
            setlocalNotification()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDCPathButton() {
        
        dcPathButton = DCPathButton(centerImage: UIImage(named: "add-circle-blue-sm"), highlightedImage: UIImage(named: "add-circle-blue-sm"))
        
        dcPathButton.delegate = self
        dcPathButton.dcButtonCenter = CGPointMake(self.view.bounds.width/2, self.view.bounds.height - 25.5)
        dcPathButton.allowSounds = true
        dcPathButton.allowCenterButtonRotation = true
        dcPathButton.bloomRadius = 105
        dcPathButton.bottomViewColor = UIColor.whiteColor()
        
        
        let itemButton_1 = DCPathItemButton(image: UIImage(named: "calendar-icon"), highlightedImage: UIImage(named: "calendar-icon"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_2 = DCPathItemButton(image: UIImage(named: "settings-icon"), highlightedImage: UIImage(named: "settings-icon"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_3 = DCPathItemButton(image: UIImage(named: "notifications-icon"), highlightedImage: UIImage(named: "notifications-icon"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        let itemButton_4 = DCPathItemButton(image: UIImage(named: "goals-icon"), highlightedImage: UIImage(named: "chooser-moment-icon-sleep-highlighted"), backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted"))
        
        dcPathButton.addPathItems([itemButton_1, itemButton_2, itemButton_3, itemButton_4])
        
        self.view.addSubview(dcPathButton)
        
    }
    
    // DCPathButton Delegate
    func pathButton(dcPathButton: DCPathButton!, clickItemButtonAtIndex itemButtonIndex: UInt) {
        
        switch itemButtonIndex {
        case 0:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("CalenderView") as!CalendarViewController
            viewController.userSessionsCount = userSessionsCount
            viewController.userSessions = userSessions
            navigationController?.pushViewController(viewController, animated: true)
            
        case 1:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("SettingView") as!SettingsViewController
            viewController.blockSessions = blockSessions
            navigationController?.pushViewController(viewController, animated: true)
            
        case 2:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("ArticleTableView") as! NotificationTableViewController
            viewController.notifications = notifications
            navigationController?.showViewController(viewController, sender: true)
        case 3:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewControllerWithIdentifier("GoalTableView") as! GoalTableViewController
            viewController.goals = goals
            navigationController?.showViewController(viewController, sender: true)
            
        default:
            print("Wrong item clicked")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        
    }
    
    func getUserGoals() {
        
        self.goals.removeAll()
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/goals"
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300  else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                //if let goalsList = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                //let origin = jsonDictionary["origin"] as! String
                //print(origin)
                
                let json = jsonDictionary
                let count: Int? = json.count
                //print("found \(count!) challenges")
                
                if json.count > 0 {
                    if let ct = count {
                        for index in 0...ct-1 {
                            let name: String = json[index]["name"] as! String
                            let end_datetime: String = json[index]["end_datetime"] as! String
                            let start_datetime: String = json[index]["start_datetime"] as! String
                            let id = String (json[index]["id"] as! NSNumber)
                            let target_burn_calories = Int(json[index]["target_burn_calories"] as! NSNumber)
                            let target_distance = Int(json[index]["target_distance"] as? NSNumber ?? 0)
                            let user_id: String = json[index]["user_id"] as! String
                            let goal1 = Goal(name: name, end_datetime: end_datetime, start_datetime: start_datetime, id: id, target_burn_calories: target_burn_calories, target_distance: target_distance, user_id: user_id  )!
                            
                            self.goals.append(goal1)
                            
                        }
                    }
                }
                
                
            } catch {
                print("bad things happened")
            }
        }).resume()
    }
    
    
    func getUserSessions(){
        
        userSessionsCount.removeAll()
        userSessions.removeAll()
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/sessions"
        //print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300  else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                //if let sessionsList = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                // Print what we got from the call
                //print(sessionsList)
                
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                let json = jsonDictionary
                let sessionCount: Int? = json.count
                //print("found \(sessionCount) sessions")
                
                if json.count > 0 {
                    if let ct = sessionCount {
                        for index in 0...ct-1 {
                            let session_id = String(json[index]["id"] as! NSNumber)
                            let sessionName: String = json[index]["name"] as! String
                            let workout_type_id = Int(json[index]["workout_type_id"] as! NSNumber)
                            let start_datetime: String = json[index]["start_datetime"] as! String
                            let end_datetime: String = json[index]["end_datetime"] as! String
                            let session_feedback_id = String (json[index]["session_feedback_id"] as? NSNumber ?? 0)
                            let session_status: String = json[index]["session_status"] as! String
                            let type: String = json[index]["type"] as! String
                            let session1 = Session(id: session_id, sessionName: sessionName, workout_type_id: workout_type_id, start_datetime: start_datetime, end_datetime: end_datetime, session_feedback_id: session_feedback_id, session_status: session_status, type: type)!
                            let hashindex = start_datetime[start_datetime.startIndex..<start_datetime.startIndex.advancedBy(10)]
                            if (self.userSessionsCount[hashindex] == nil) {
                                self.sessions.removeAll()
                                self.userSessionsCount[hashindex] = 1
                                self.sessions.append(session1)
                                self.userSessions[hashindex] = self.sessions
                            } else{
                                self.userSessionsCount[hashindex] = self.userSessionsCount[hashindex]! + 1
                                //self.sessions.append(session1)
                                if var arr = self.userSessions[hashindex] {
                                    arr.append(session1)
                                    self.userSessions[hashindex] = arr
                                }
                            }
                            
                        }
                        
                    }
                }
                
                
            } catch {
                print("bad things happened")
            }
        }).resume()
        
    }
    
    func getBlockedSessions(){
        
        blockSessions.removeAll()
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/blocksessions"
        //print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300  else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                //if let blockSessionsList = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                // Print what we got from the call
                // print(blockSessionsList)
                
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                let json = jsonDictionary
                let blockSessionCount: Int? = json.count
                //print("found \(sessionCount) sessions")
                
                if json.count > 0 {
                    
                    if let ct = blockSessionCount {
                        for index in 0...ct-1 {
                            
                            let id = json[index]["id"] as! Int
                            let day: String = json[index]["day_of_week"] as! String
                            let start_time: String = json[index]["start_time"] as! String
                            let end_time: String = json[index]["end_time"] as! String
                            
                            let bsObject = BlockSession(id: id, startTime: start_time, endTime: end_time, selectedDay: day)!
                            self.blockSessions.append(bsObject)
                            
                            
                        }
                        
                    }
                }
                
                
            } catch {
                print("bad things happened")
            }
        }).resume()
        
    }
    
    func getNotifications(){
        self.notifications.removeAll()
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        // Setup the session to make REST GET call.  Notice the URL is https NOT http!!
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/notifications/sessions"
        //print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300  else {
                    print("Not a 200 response")
                    return
            }
            
            // Read the JSON
            do {
                //if let recommedation = NSString(data:data!, encoding: NSUTF8StringEncoding) {
                // Print what we got from the call
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                let json = jsonDictionary
                let notificationCount: Int? = json.count
                if json.count > 0 {
                    if let ct = notificationCount {
                        for index in 0...ct-1 {
                            
                            let session_id = String(json[index]["id"] as! NSNumber)
                            let sessionName: String = json[index]["name"] as! String
                            let workout_type_id = Int(json[index]["id"] as! NSNumber)
                            let start_datetime: String = json[index]["start_datetime"] as! String
                            let end_datetime: String = json[index]["end_datetime"] as! String
                            let session_feedback_id = String (json[index]["session_feedback_id"] as! NSNumber)
                            let session_status: String = json[index]["session_status"] as! String
                            let type: String = json[index]["type"] as! String
                            
                            let recommendation = Notification(id: session_id, sessionName: sessionName, workout_type_id: workout_type_id, start_datetime: start_datetime, end_datetime: end_datetime, session_feedback_id: session_feedback_id, session_status: session_status, type: type)!
                            
                            self.notifications.append(recommendation)
                            
                            
                        }
                        
                    }
                }
                
                
                
            } catch {
                print("bad things happened")
            }
        }).resume()
        
    }
    
    func setLineChart(dataPoints: [String], values: [Double], xValues :[String]!) {
        hoursLineChart.noDataText = "No data available"
        hoursLineChart.pinchZoomEnabled = true
        //hoursLineChart.zoomOut()
        //hoursLineChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInCubic)
        hoursLineChart.descriptionText = ""
        
        hoursLineChart.xAxis.labelPosition = .Bottom
        hoursLineChart.xAxis.drawGridLinesEnabled = false
        hoursLineChart.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        hoursLineChart.xAxis.labelFont = UIFont.systemFontOfSize(10)
        hoursLineChart.xAxis.drawGridLinesEnabled = false
        hoursLineChart.xAxis.spaceBetweenLabels = 2
        
        hoursLineChart.leftAxis.drawGridLinesEnabled = false
        hoursLineChart.leftAxis.labelFont = UIFont.systemFontOfSize(10)
        hoursLineChart.leftAxis.labelCount = 8;
        hoursLineChart.leftAxis.labelPosition = ChartYAxis.YAxisLabelPosition.OutsideChart
        hoursLineChart.leftAxis.spaceTop = 0.15;
        hoursLineChart.leftAxis.axisMinValue = 0.0; // this replaces startAtZero = YES
        
        hoursLineChart.rightAxis.enabled = false
        hoursLineChart.rightAxis.drawGridLinesEnabled = false
        hoursLineChart.rightAxis.drawGridLinesEnabled = false
        hoursLineChart.rightAxis.labelFont = UIFont.systemFontOfSize(10)
        hoursLineChart.rightAxis.labelCount = 8;
        hoursLineChart.rightAxis.spaceTop = 0.15;
        hoursLineChart.rightAxis.axisMinValue = 0.0; // this replaces startAtZero = YES
        
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = LineChartDataSet(yVals: dataEntries, label: "Distance Covered in kilometers")
        chartDataSet.drawCubicEnabled = true
        chartDataSet.circleRadius = 0.2
        chartDataSet.lineWidth = 1.8
        chartDataSet.circleRadius = 4.0
        chartDataSet.setColor(UIColor.flatSkyBlueColor())
        chartDataSet.setCircleColor(NSUIColor.darkGrayColor())
        chartDataSet.drawValuesEnabled = false
        
        let chartData = LineChartData(xVals: xValues, dataSet: chartDataSet)
        hoursLineChart.data = chartData
        
    }
    
    func setBarChart(dataPoints: [String], values: [Double], xValues :[String]!) {
        barChartView.noDataText = "No data available"
        barChartView.drawBarShadowEnabled = false;
        
        barChartView.pinchZoomEnabled = false
        barChartView.drawGridBackgroundEnabled = false
        barChartView.rightAxis.enabled = false
        barChartView.xAxis.labelPosition = .Bottom
        
        barChartView.xAxis.drawGridLinesEnabled = true
        barChartView.leftAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.drawGridLinesEnabled = false
        //barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .EaseInOutExpo)
        barChartView.descriptionText = ""
        barChartView.xAxis.axisMinValue = 0.0
        barChartView.rightAxis.minWidth = 1
        
        barChartView.xAxis.labelPosition = ChartXAxis.XAxisLabelPosition.Bottom
        barChartView.xAxis.labelFont = UIFont.systemFontOfSize(10)
        barChartView.xAxis.drawGridLinesEnabled = false
        barChartView.xAxis.spaceBetweenLabels = 2
        
        
        barChartView.leftAxis.labelFont = UIFont.systemFontOfSize(10)
        barChartView.leftAxis.labelCount = 8;
        barChartView.leftAxis.labelPosition = ChartYAxis.YAxisLabelPosition.OutsideChart
        barChartView.leftAxis.spaceTop = 0.15;
        barChartView.leftAxis.axisMinValue = 0.0; // this replaces startAtZero = YES
        
        barChartView.rightAxis.drawGridLinesEnabled = false
        barChartView.rightAxis.labelFont = UIFont.systemFontOfSize(10)
        barChartView.rightAxis.labelCount = 8;
        barChartView.rightAxis.spaceTop = 0.15;
        barChartView.rightAxis.axisMinValue = 0.0; // this replaces startAtZero = YES
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Calories burnt in cal")
        chartDataSet.barSpace = 0.5
        chartDataSet.setColor(UIColor.flatSkyBlueColor())
        chartDataSet.drawValuesEnabled = false
        let chartData = BarChartData(xVals: xValues, dataSet: chartDataSet)
        barChartView.data = chartData
    }
    
    func getUserAnalyticsTest(){
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/analytics" // Your Normal URL String
        let url = NSURL(string: urlString)// Creating URL
        let request = NSURLRequest(URL: url!) // Creating Http Request
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        // Sending Synchronous request using NSURLConnection
        do {
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting data to String
            //let responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
            //print(responseStr)
            
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            //print(jsonDictionary)
            
            let json = jsonDictionary
            
            if json.count > 0 {
                
                dayCalories = json["day"]!["calories"]! as! [Double]
                dayDistances = json["day"]!["distance"]! as! [Double]
                dayHours = json["day"]!["hours"]! as! [String]
                
                monthCalories = json["month"]!["calories"]! as! [Double]
                monthDistances = json["month"]!["distance"]! as! [Double]
                monthDates = json["month"]!["dates"]! as! [String]
                
                weekCalories = json["week"]!["calories"]! as! [Double]
                weekDistances = json["week"]!["distance"]! as! [Double]
                weekDays = json["week"]!["weekdays"]! as! [String]
            }
            
        } catch (let e) {
            print(e)
            // You can handle error response here
        }
    }
    
    
    
    func showAMessage(notification:NSNotification){
        let message:UIAlertController = UIAlertController(title: "Session Notification Message", message: "Start your workout session", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
    }
    
    func getTodaysSession(){
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        let currentDate = NSDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let convertedDate = dateFormatter.stringFromDate(currentDate)
        
        let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/sessions?day=" + convertedDate // Your Normal URL String
        let url = NSURL(string: urlString)// Creating URL
        let request = NSURLRequest(URL: url!) // Creating Http Request
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        // Sending Synchronous request using NSURLConnection
        do {
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting data to String
            //let responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
            //print(responseStr)
            
            // Parse the JSON to get the IP
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            let json = jsonDictionary
            //print("found \(sessionCount) sessions")
            
            if(json.count > 0)
            {
                self.todaysDate = json[0]["start_datetime"] as! String
            }
            
            
            
        } catch (let e) {
            print(e)
            // You can handle error response here
        }
    }
    
    func setlocalNotification(){
        //var str = "2016-02-28 19:00:00"
        
        //UIApplication.sharedApplication().cancelLocalNotification(notification)
        
        let myNSString = todaysDate as NSString
        
        let dateComp:NSDateComponents = NSDateComponents()
        dateComp.year = Int(myNSString.substringWithRange(NSRange(location: 0, length: 4)))!
        dateComp.month = Int(myNSString.substringWithRange(NSRange(location: 5, length: 2)))!
        dateComp.day = Int(myNSString.substringWithRange(NSRange(location: 8, length: 2)))!
        dateComp.hour = Int(myNSString.substringWithRange(NSRange(location: 11, length: 2)))!
        dateComp.minute = Int(myNSString.substringWithRange(NSRange(location: 14, length: 2)))!
        dateComp.timeZone = NSTimeZone.systemTimeZone()
        
        let calender:NSCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
        let date:NSDate = calender.dateFromComponents(dateComp)!
        
        
        self.notification = UILocalNotification()
        self.notification.category = "FIRST_CATEGORY"
        self.notification.alertBody = "Hi, you have your session due now"
        self.notification.fireDate = date
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
}

