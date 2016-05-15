//
//  ConnectedAccountSettingsVC.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/22/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka
import SwiftValidator

class ConnectedAccountSettingsVC: FormViewController {
    
    var userGoogleAccountCount: Int! = 0
    var googleUserName: String! = ""
    let localDB = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let googleUserName: String = localDB.objectForKey("googleUserName") as? String ?? ""
        
        //getGoogleUserConnection()
        
        form =
            Section()
            +++ Section()
            +++ Section("Google Calendar Accounts")
            
            <<< SVTextRow() {
                
                //let google_id: String = localDB.objectForKey("gmail") as! String
                $0.tag = "gmailUserName"
                //                if(googleUserName != " " && googleUserName != ""){
                //                    $0.value = googleUserName
                //                    //$0.cell.textLabel?.textColor = UIColor.greenColor()
                //                    $0.cell.backgroundColor = UIColor.flatGreenColor()
                //                    }
//                if(userGoogleAccountCount > 0){
//                    $0.value =
//                    //$0.cell.textLabel?.textColor = UIColor.greenColor()
//                    $0.cell.backgroundColor = UIColor.flatGreenColor()
//                }
                $0.title =  "Gmail Id"
                $0.placeholder = "user email id"
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
                
            }
            
            +++ Section()
            
            <<< ButtonRow("Connect Google Calendar") {
                $0.title = $0.tag
                //$0.presentationMode = .SegueName(segueName: "GoogleWebViewSegue", completionCallback: nil)
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.blueColor()
                }
                .onCellSelection({ (cell, row) in
                    //cell.textLabel?.textAlignment = NSTextAlignment.Left
                    let dataValid = self.form.validateAll()
                    
                    if(dataValid && self.form.rowByTag("gmailUserName")!.baseValue != nil){
                        self.performSegueWithIdentifier("GoogleWebViewSegue", sender: self)
                        
                    }
                    
                })
            
            +++ Section()
            
            <<< ButtonRow("Remove Google Calendar") {
                $0.title = $0.tag
                //$0.presentationMode = .SegueName(segueName: "GoogleWebViewSegue", completionCallback: nil)
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.blueColor()
                }
                .onCellSelection({ (cell, row) in
                    //cell.textLabel?.textAlignment = NSTextAlignment.Left
                    let dataValid = self.form.validateAll()
                    
                    if(dataValid && self.form.rowByTag("gmailUserName")!.baseValue != nil){
                        self.removeGoogleUserConnection()
                        
                    }
                    
                })
            
            +++ Section()
    }
    
    @IBAction func unwindConnectedAccountsToSettingsHome(sender: UIStoryboardSegue) {
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        getGoogleUserConnection()
        
        if(userGoogleAccountCount > 0){
           self.form.rowByTag("gmailUserName")!.baseValue  = self.googleUserName
            //$0.cell.textLabel?.textColor = UIColor.greenColor()
          self.form.rowByTag("gmailUserName")?.baseCell.backgroundColor = UIColor.flatGreenColor()
        }
        
    }
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "GoogleWebViewSegue") {
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_id = localDB.objectForKey("user_email") as! String!
            //Checking identifier is crucial as there might be multiple
            // segues attached to same view
            let webViewController = segue.destinationViewController as! WebViewController
            let googleUserName: String = form.rowByTag("gmailUserName")!.baseValue as! String
            
            webViewController.toUserName = user_id
            webViewController.toEmail = googleUserName.lowercaseString //+ "@gmail.com"
            
            localDB.setObject(googleUserName.lowercaseString, forKey: "googleUserName")
            
        }
    }
    
    
    func getGoogleUserConnection(){
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id = localDB.objectForKey("user_email") as! String!
        
        let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/calendars/google" // Your Normal URL String
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
            let googleConnectionCount: Int? = json.count
            //print("found \(sessionCount) sessions")
            
            if(googleConnectionCount > 0){
                self.userGoogleAccountCount = googleConnectionCount
                self.googleUserName = json[0]["email"] as? String ?? ""
            
            }
            
        } catch (let e) {
            print(e)
            // You can handle error response here
        }
    }
    
    func removeGoogleUserConnection(){
        
        let removeUserName: String = form.rowByTag("gmailUserName")!.baseValue as! String
        self.form.rowByTag("gmailUserName")?.baseCell.backgroundColor = UIColor.whiteColor()
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id = localDB.objectForKey("user_email") as! String!
        
        let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/calendars/google/" + removeUserName // + "@gmail.com" // Your Normal URL String
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        urlRequest.HTTPMethod = "DELETE"
        
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) in
            guard let _ = data else {
                print("error calling DELETE on Google Account")
                return
            }
            print("DELETE success")
            
        }
        task.resume()
        
    }
}



