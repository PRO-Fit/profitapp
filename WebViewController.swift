//
//  WebViewController.swift
//  googleSignIn
//
//  Created by Saumil Dharia on 3/19/16.
//  Copyright © 2016 SaumilDharia. All rights reserved.
//

import Foundation

import UIKit

class WebViewController: UIViewController {
    
    var toEmail: String!
    var toUserName : String!
    var userGoogleAccountCount = 0

    @IBOutlet weak var googleWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/calendars/google/oauth2/" + self.toUserName! + "/" + self.toEmail!
        googleWebView.loadRequest(NSURLRequest(URL: NSURL(string: url )!))
        // Do any additional setup after loading the view, typically from a nib.
        //getUserGoogleInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
//        getUserGoogleInfo()
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewControllerWithIdentifier("ConnectAccountView") as! ConnectedAccountSettingsVC
//        
//        controller.userGoogleAccountCount = self.userGoogleAccountCount
//        
//        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    
    func getUserGoogleInfo(){
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_id: String = localDB.objectForKey("user_email") as! String
        
        
        let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)/calendars/google"
        //print(postEndpoint)
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: postEndpoint)!
        
        // Make the POST call and handle it in a completion handler
        session.dataTaskWithURL(url, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            // Make sure we get an OK response
            guard let realResponse = response as? NSHTTPURLResponse where
                realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
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
                    self.userGoogleAccountCount = json.count
                
                
                
            } catch {
                print("bad things happened")
            }
        }).resume()
        

    }
    
        
}

