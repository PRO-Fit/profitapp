//
//  GoalTableViewController.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class BlockSessionTableViewController: UITableViewController {
    
    // MARK: Properties
    
    var blockSessions = [BlockSession]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserBlockedSessions()
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
        return blockSessions.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "BlockSessionTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! BlockSessionTableViewCell
        
        let blockSessionData = blockSessions[indexPath.row]
        cell.dayAndTime.text = blockSessionData.selectedDay + " : " + blockSessionData.startTime + " - " + blockSessionData.endTime
        
        
        return cell
    }
    
    
    @IBAction func unwindToBlockSessionListView(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? NewBlockSessionViewController, bs = sourceViewController.blockSessionObj {
            // Add a new meal.
            let newIndexPath = NSIndexPath(forRow: blockSessions.count, inSection: 0)
            blockSessions.append(bs)
            tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Bottom)
        }
        
        if let sourceViewController = sender.sourceViewController as? BlockSessionDetailViewController, session = sourceViewController.blockSessionObj {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing meal.
                blockSessions[selectedIndexPath.row] = session
                tableView.reloadRowsAtIndexPaths([selectedIndexPath], withRowAnimation: .None)
            }
            else {
                // Add a new meal.
                let newIndexPath = NSIndexPath(forRow: blockSessions.count, inSection: 0)
                blockSessions.append(session)
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
            
            let blockSessionID: Int = blockSessions[indexPath.row].id
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id: String = localDB.objectForKey("user_email") as! String
            
            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/blocksessions/\(blockSessionID)"
            
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: postEndpoint)!)
            urlRequest.HTTPMethod = "DELETE"
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(urlRequest) {
                (data, response, error) in
                guard let _ = data else {
                    print("error calling DELETE on Block Session")
                    return
                }
                print("DELETE success")
                self.blockSessions.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
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
        //Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showDetailBlockSession" {
            let blockSessionDetailViewController = segue.destinationViewController as! BlockSessionDetailViewController
            
            // Get the cell that generated this segue.
            if let selectedBlockSessionCell = sender as? BlockSessionTableViewCell {
                let indexPath = tableView.indexPathForCell(selectedBlockSessionCell)!
                let selectedBlockSession = blockSessions[indexPath.row]
                blockSessionDetailViewController.blockSessionObj = selectedBlockSession
            }
        }
        else if segue.identifier == "addBlockSession" {
            print("Adding new Block Session.")
        }
    }
    
    func getUserBlockedSessions(){
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/blocksessions" // Your Normal URL String
        let url = NSURL(string: urlString)// Creating URL
        let request = NSURLRequest(URL: url!) // Creating Http Request
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        // Sending Synchronous request using NSURLConnection
        do {
            let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting data to String
           // let responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
            //print(responseStr)
            
            // Parse the JSON to get the IP
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            
            let json = jsonDictionary
            let blockSessionCount: Int? = json.count
            //print("found \(sessionCount) sessions")
            
            if let ct = blockSessionCount {
                for index in 0...ct-1 {
                    
                    let id: Int = json[index]["id"] as! Int
                    let day: String = json[index]["day_of_week"] as! String
                    let start_time: String = json[index]["start_time"] as! String
                    let end_time: String = json[index]["end_time"] as! String
                    
                    let bsObject = BlockSession(id: id, startTime: start_time, endTime: end_time, selectedDay: day)!
                    self.blockSessions.append(bsObject)
                }
            }
            
            
        } catch (let e) {
            print(e)
            // You can handle error response here
        }
    }
    
    
}
