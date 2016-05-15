//
//  GoalTableViewController.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class SessionTableViewController: UITableViewController {
    
    // MARK: Properties
    
    
    var sessions: [Session]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem()
        //navigationItem.leftBarButtonItem = editButtonItem()
        //loadSampleGoals()
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sessions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SessionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SessionTableViewCell
        
        let session = sessions[indexPath.row]
//        let date = session.start_datetime[session.start_datetime.startIndex..<session.start_datetime.startIndex.advancedBy(10)]
        cell.sessionName.text = session.sessionName
        cell.startDateTimeLabel.text = sessions[indexPath.row].start_datetime
        cell.endDateTimeLabel.text = session.end_datetime
        
        return cell
    }
    
    
    @IBAction func unwindToSessionHome(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? NewSessionViewController, session = sourceViewController.sessionObj {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                sessions[selectedIndexPath.row] = session
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: sessions.count, inSection: 0)
                sessions.append(session)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }

        }
        
        if let sourceViewController = sender.sourceViewController as? DetailSessionViewController, session = sourceViewController.sessionObj {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                sessions[selectedIndexPath.row] = session
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: sessions.count, inSection: 0)
                sessions.append(session)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
            
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            print("I'm in Delete Handler..")
            
            let session_id: String = sessions[indexPath.row].id
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            
            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/sessions/\(session_id)"
            
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            urlRequest.HTTPMethod = "DELETE"
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) in
                guard let _ = data else {
                    print("error calling DELETE on Session")
                    return
                }
                print("DELETE success")
                self.sessions.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                
            }
            task.resume()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailSession" {
            let sessionDetailViewController = segue.destinationViewController as! DetailSessionViewController
            
            // Get the cell that generated this segue.
            if let selectedSessionCell = sender as? SessionTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedSessionCell)!
                let selectedSession = sessions[indexPath.row]
                sessionDetailViewController.sessionObj = selectedSession
            }
        }
        else if segue.identifier == "AddSession" {
            print("Adding new New Session.")
        }
    }
    
}
