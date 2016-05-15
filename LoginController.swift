//
//  LoginController.swift
//  SlideOutMenu
//
//  Created by Saumil Dharia on 3/8/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class LoginController: UIViewController, FBSDKLoginButtonDelegate {
    
    let localDB = NSUserDefaults.standardUserDefaults()
    var window: UIWindow?
    //var navigationController: UINavigationController?
    
    @IBAction func loginAction(sender: UIButton) {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("User Already Logged In")
            self.returnUserData()
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            
            //let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //self.view.addSubview(loginView)
            //loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.delegate = self
        }
        
    }
    
    var player: AVPlayer?
    var fb_id: String = ""
    
    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the video from the app bundle.
        let videoURL: NSURL = NSBundle.mainBundle().URLForResource("background", withExtension: "mp4")!
        
        player = AVPlayer(URL: videoURL)
        player?.actionAtItemEnd = .None
        player?.muted = true
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        playerLayer.zPosition = -1
        
        playerLayer.frame = view.frame
        
        view.layer.addSublayer(playerLayer)
        
        player?.play()
        
        //loop video
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(LoginController.loopVideo),
                                                         name: AVPlayerItemDidPlayToEndTimeNotification,
                                                         object: nil)
        
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            print("User Already Logged In")
            self.returnUserData()
            // User is already logged in, do work such as go to next view controller.
        }
        else
        {
            
            //let loginView : FBSDKLoginButton = FBSDKLoginButton()
            //self.view.addSubview(loginView)
            //loginButton.center = self.view.center
            loginButton.readPermissions = ["public_profile", "email", "user_friends"]
            loginButton.delegate = self
        }
    }
    
    func loopVideo() {
        player?.seekToTime(kCMTimeZero)
        player?.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                self.returnUserData()
                // Do work
                //self.Continue.hidden = false
                let user_id: String = localDB.objectForKey("user_email") as? String ?? ""
                if(user_id ==  ""){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewControllerWithIdentifier("welcomeScreenPageView") as! TutorialViewController
                    //self.navigationController?.pushViewController(viewController, animated: true)
                    self.presentViewController(viewController, animated: false, completion: nil)
                }
                else{
                    let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                    let navBarController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("NavigatorView") as! UINavigationController
                    
                    //self.showViewController(navBarController, animated: false, completion: nil)
                    self.presentViewController(navBarController, animated: false, completion: nil)
                    //self.window?.makeKeyAndVisible()
                    //self.window?.rootViewController = navBarController
                }
                
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me?fields=picture,email,first_name,gender,last_name,location,timezone,birthday", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                print("fetched user: \(result)")
                if(result != nil)
                {
                    
                }
                let userEmail : NSString = result.valueForKey("email") as! NSString
                if result.valueForKey("id") != nil {
                    self.fb_id = result.valueForKey("id") as! String
                    NSUserDefaults.standardUserDefaults().setObject(self.fb_id, forKey: "fb_id")
                }
                print("User Email is: \(userEmail)")
                NSUserDefaults.standardUserDefaults().setObject(userEmail, forKey: "user_email")
            }
        })
    }
    
    
}
