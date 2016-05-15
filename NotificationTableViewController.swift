//
//  FirstTabViewController.swift
//  TabbarApp
//
//  Created by Allen on 16/2/4.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit
import SCLAlertView
import ChameleonFramework


class NotificationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var articleTableView: UITableView!
    
    var notifications: [Notification]!
    var article: Notification!
    var articleIndexpath: NSIndexPath!
    var articleRow: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setStatusBarStyle(UIStatusBarStyleContrast)
        //articleTableView.editing = true
        
        
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        articleTableView.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    
    @IBAction func onBackClickHandler(sender: UIBarButtonItem) {
        let isPresentingInNavigationMode = presentingViewController is UINavigationController
        
        if isPresentingInNavigationMode {
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            navigationController!.popViewControllerAnimated(true)
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        animateTable()
        
    }
    
    func animateTable() {

        self.articleTableView.reloadData()
        
        let cells = articleTableView.visibleCells
        let tableHeight: CGFloat = articleTableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.notifications.count == 0{
            let emptyLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            emptyLabel.textAlignment = NSTextAlignment.Center
            emptyLabel.text = "No Notifications Available"
            
            self.articleTableView.backgroundView = emptyLabel
            self.articleTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            return 0
        } else {

            return notifications.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = articleTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! NotificationTableViewCell
        
        let article = notifications[indexPath.row]
        
        
        cell.activityType.text = article.type
        cell.feedType.text = "Session Recommendation"
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = .ShortStyle
        
        let startDate = dateFormatter.dateFromString(article.start_datetime)
        let endDate = dateFormatter.dateFromString(article.end_datetime)
        
        let timestamp = NSDateFormatter.localizedStringFromDate(startDate!, dateStyle: .MediumStyle, timeStyle: .NoStyle)
        let startTimeText = timeFormatter.stringFromDate(startDate!)
        let endTimeText = timeFormatter.stringFromDate(endDate!)
        
        cell.recoDateText.text = timestamp
        
        cell.timeRangeText.text = startTimeText + " to " + endTimeText
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
        
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        article = notifications[indexPath.row]
        
        articleIndexpath = indexPath
        articleRow = indexPath.row
        
        let alertView = SCLAlertView()
        
        alertView.addButton("Accept", target:self, selector:#selector(NotificationTableViewController.acceptRecommendation))
        alertView.addButton("Ignore"){
            print("Ignore button tapped...")
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            
            let putEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/notifications/sessions/\(self.article.id)?session_status=REC_REJECTED"
            
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: putEndpoint)!)
            urlRequest.HTTPMethod = "PUT"
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) in
                guard let _ = data else {
                    print("error calling PUT on Notification")
                    return
                }
                print("PUT success")
                
            }
            task.resume()
            self.notifications.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//            self.articleTableView.reloadData()
            
        }
        alertView.showTitle(
            "Great!", // Title of view
            subTitle: "Do you want to add this session to your calendar ?", // String of view
            duration: 0.0,
            completeText: "Close", // Optional button value, default: ""
            style: .Success, // Styles - see below.
            colorStyle: 0x2866BF,
            colorTextButton: 0xFFFFFF
        )
        
        
        // TODO: Need to remove a recommendation fromt the UI TableView (currently, throws errors if the count = 0 after removal)
        
        
    }
    
    func acceptRecommendation(sender: AnyObject?) {
        self.notifications.removeAtIndex(articleRow)
        articleTableView.deleteRowsAtIndexPaths([articleIndexpath], withRowAnimation: .Fade)
    
        print("Accept button tapped...")
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        let putEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/notifications/sessions/\(article.id)?session_status=REC_ACCEPTED"
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: putEndpoint)!)
        urlRequest.HTTPMethod = "PUT"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let _ = data else {
                print("error calling PUT on Notification")
                return
            }
            print("PUT success")
            
        }
        task.resume()
        //tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
    
}