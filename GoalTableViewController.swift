//
//  GoalTableViewController.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class GoalTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var goals: [Goal]!
    
    
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
        return goals.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "GoalTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! GoalTableViewCell
        
        let goal = goals[indexPath.row]
        
        cell.name.text = goal.name        
        cell.startDateTextField.text = goal.start_datetime
        cell.endDateTextField.text = goal.end_datetime
        
        return cell
    }
    
    
    @IBAction func unwindToGoalListView(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.sourceViewController as? GoalViewController, goal = sourceViewController.goal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                goals[selectedIndexPath.row] = goal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: goals.count, inSection: 0)
                goals.append(goal)
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
            }
        }
        
        if let sourceViewController = sender.sourceViewController as? GoalDetailViewController, goal = sourceViewController.goal {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                goals[selectedIndexPath.row] = goal
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: goals.count, inSection: 0)
                goals.append(goal)
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
            
            let goal_id: String = goals[indexPath.row].id
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            
            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/goals/\(goal_id)"
            
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            urlRequest.HTTPMethod = "DELETE"
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) in
                guard let _ = data else {
                    print("error calling DELETE on Goal")
                    return
                }
                print("DELETE success")
                self.goals.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
            }
            task.resume()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailGoal" {
            let goalDetailViewController = segue.destinationViewController as! GoalDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedGoalCell = sender as? GoalTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedGoalCell)!
                let selectedGoal = goals[indexPath.row]
                goalDetailViewController.goal = selectedGoal
            }
        }
        else if segue.identifier == "addGoal" {
            print("Adding new Goal.")
        }
    }
    
}
