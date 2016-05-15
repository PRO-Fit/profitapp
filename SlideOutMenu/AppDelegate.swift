//
//  AppDelegate.swift
//  SlideOutMenu
//
//  Created by Allen on 16/1/30.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit
import ChameleonFramework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        
        
        
        // Actions
        let firstAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        firstAction.identifier = "FIRST_ACTION"
        firstAction.title = "Dissmiss"
        
        firstAction.activationMode = UIUserNotificationActivationMode.Background
        firstAction.destructive = true
        firstAction.authenticationRequired = false
        
        let secondAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        secondAction.identifier = "SECOND_ACTION"
        secondAction.title = "Open PRO-fit"
        
        secondAction.activationMode = UIUserNotificationActivationMode.Foreground
        secondAction.destructive = false
        secondAction.authenticationRequired = false
        
        let thirdAction:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        thirdAction.identifier = "THIRD_ACTION"
        thirdAction.title = "Third Action"
        
        thirdAction.activationMode = UIUserNotificationActivationMode.Background
        thirdAction.destructive = false
        thirdAction.authenticationRequired = false
        
        
        // category
        
        let firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        
        let defaultActions:NSArray = [firstAction, secondAction, thirdAction]
        let minimalActions:NSArray = [firstAction, secondAction]
        
        firstCategory.setActions(defaultActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions as? [UIUserNotificationAction], forContext: UIUserNotificationActionContext.Minimal)
        
        // NSSet of all our categories
        
        let categories:NSSet = NSSet(objects: firstCategory)
        
        
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: categories as? Set<UIUserNotificationCategory>))  // types are UIUserNotificationType properties


        UIStatusBarStyle.LightContent
        navigationController = UINavigationController()
        
        FBSDKApplicationDelegate.sharedInstance().application(application,didFinishLaunchingWithOptions: launchOptions)
        // If we have a cached user, we'll get it back here
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // A user was cached, so skip straight to the main view
            presentWallViewController(animated: false)
        } else {
            // No cached user, go to the welcome screen and
            // have them log in or create an account.
            presentLoginController(animated: true)
        }
        

        UINavigationBar.appearance().barTintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.9, alpha: 1.0)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor() ]
        UINavigationBar.appearance().barTintColor = UIColor(hue: 0.5778, saturation: 1, brightness: 0.9, alpha: 1.0)
        
        return true
    }
    
    func application(application: UIApplication,
                     handleActionWithIdentifier identifier:String?,
                                                forLocalNotification notification:UILocalNotification,
                                                                     completionHandler: (() -> Void)){
        
        if (identifier == "FIRST_ACTION"){
            
            NSNotificationCenter.defaultCenter().postNotificationName("Session dismissed", object: nil)
            
        }else if (identifier == "SECOND_ACTION"){
            NSNotificationCenter.defaultCenter().postNotificationName("Session accepted by user", object: nil)
            
        }
        
        completionHandler()
        
    }

    
    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool
    {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
    func presentWallViewController(animated animated: Bool) {
        NSLog("Presenting Home Page")
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let navBarController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("NavigatorView") as! UINavigationController
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = navBarController
        
    }
    
    func presentLoginController( animated animated: Bool) {
        NSLog("Presenting Login view controller")
        
        // Go to the welcome screen and have them log in or create an account.
        let storyboard = UIStoryboard(name: "Main", bundle: nil) // Here you need to replace "Main" by the name of your storyboard as defined in interface designer
        let viewController = storyboard.instantiateViewControllerWithIdentifier("LoginController") as! LoginController
        window?.makeKeyAndVisible()
        //window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.rootViewController = viewController
        
    }
    
    
    
}


