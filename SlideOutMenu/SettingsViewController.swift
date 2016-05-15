//
//  SettingsViewController.swift
//  Example-Swift
//
//  Created by Saumil Dharia on 3/27/16.
//  Copyright © 2016 DC. All rights reserved.
//

import Foundation
import Eureka
import UIKit

class SettingsViewController: FormViewController {
    
    var blockSessions: [BlockSession]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        form =
            Section()
            +++ Section()
            +++ Section("User Account")
            
            <<< ButtonRow("Profile") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "settingUserProfileSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Preferences") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "settingUserPreferenesSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Block Session(s)") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "settingUserBlockSessionSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Connected Accounts") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "settingConnectedAccountsSegue", completionCallback: nil)
            }
            <<< ButtonRow("About Us") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "settingAboutUsSegue", completionCallback: nil)
            }
            
            <<< ButtonRow("Logout") {
                $0.title = $0.tag
                $0.presentationMode = .SegueName(segueName: "showLoginController", completionCallback: nil)
                //.Show(controllerProvider: LoginController, completionCallback: nil )
                
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        
        if (segue.identifier == "settingUserProfileSegue") {
            
            let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)"
            let url = NSURL(string: urlString)// Creating URL
            let request = NSURLRequest(URL: url!) // Creating Http Request
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            // Sending Synchronous request using NSURLConnection
            do {
                let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting data to String
                let responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
                //print(responseStr)
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
                
                let json = jsonDictionary
                
                if json.count > 0 {
                    let viewController: ProfileSettingsVC = segue.destinationViewController as! ProfileSettingsVC
                    viewController.userData = json
                }
                
                
            } catch (let e) {
                print(e)
                // You can handle error response here
            }
            
            
            
        } else if(segue.identifier == "settingUserPreferenesSegue"){
            
            let urlString = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/preferences"
            let url = NSURL(string: urlString)// Creating URL
            let request = NSURLRequest(URL: url!) // Creating Http Request
            let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
            // Sending Synchronous request using NSURLConnection
            do {
                let responseData = try NSURLConnection.sendSynchronousRequest(request, returningResponse: response) //Converting data to String
                //let responseStr:NSString = NSString(data:responseData, encoding:NSUTF8StringEncoding)!
                //print(responseStr)
                
                // Parse the JSON to get the IP
                let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                let json = jsonDictionary
                
                if json.count > 0 {
                    let viewController: PreferencesSettingsVC = segue.destinationViewController as! PreferencesSettingsVC
                    viewController.userPreferencesData = json
                }
                
                
            } catch (let e) {
                print(e)
                // You can handle error response here
            }
            
            
        }
        
    }
}