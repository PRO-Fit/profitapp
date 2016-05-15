//
//  ProfileSettingsVC.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/22/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka
import SwiftValidator

class ProfileSettingsVC: FormViewController {
    
    var userData: NSArray = []
    
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form =
            
            Section()
            
            +++ Section()
            
            +++ Section("User Profile")
            
            <<< SVTextRow() {
                $0.tag = "firstNameTextField"
                $0.title =  "First Name"
                $0.placeholder = "First Name"
                $0.value = userData[0]["first_name"] as? String
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
            }
            
            <<< SVTextRow() {
                $0.tag = "lastNameTextField"
                $0.title =  "Last Name"
                $0.placeholder = "Last Name"
                $0.value = userData[0]["last_name"] as? String
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
            }
            
            <<< DateRow() {
                $0.tag = "dateOfBirthTextField"
                $0.value = NSDate()
                $0.title = "Date of Birth"
                let userDOB = userData[0]["dob"] as? String
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                let dobDateFormat = dateFormatter.dateFromString(userDOB!)
                $0.value = dobDateFormat
                
                
                }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            
            
            <<< SegmentedRow<String>() {
                $0.tag = "genderTextField"
                $0.title = "Gender"
                $0.options = ["Male", "Female"]
                
                
                if(userData[0]["gender"] as? String == "M") {
                    $0.value = "Male"
                }else{
                    $0.value = "Female"
                }
                
            }
            
            <<< SVPhoneRow() {
                $0.tag = "mobileNoTextField"
                $0.title = "Mobile No"
                $0.placeholder = "Mobile No"
                $0.value = userData[0]["contact_number"] as? String
                $0.rules = [RequiredRule(), PhoneNumberRule()]
                $0.autoValidation = false
                
            }
            
            <<< EmailRow() {
                $0.tag = "emailTextField"
                $0.value = NSUserDefaults.standardUserDefaults().objectForKey("user_email") as? String
                $0.title = "Email"
                $0.disabled = true
                
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.blackColor()
            }
            
            <<< SVIntRow() {
                $0.tag = "heightTextField"
                $0.title = "Height"
                $0.placeholder = "Height (in cms)"
                $0.value = userData[0]["height"] as? Int
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
            }
            
            <<< SVIntRow() {
                $0.title = "Weight"
                $0.tag = "weightTextField"
                $0.placeholder = "Weight (in kgs)"
                $0.value = userData[0]["weight"] as? Int
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
            }
            
            <<< SVTextRow() {
                $0.tag = "injuriesTextField"
                $0.title =  "Injuries, if any"
//                $0.placeholder = "(optional)"
                $0.value = userData[0]["injuries"] as? String
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
            }
        
        +++ Section()
        
      
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        print("View is already loaded")
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func unwindProfileToSettingsHome(sender: UIStoryboardSegue) {
        //navigationController!.popViewControllerAnimated(true)
        
    }
    
    @IBAction func onCancelClick(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
    }
    
    
    @IBAction func updateClickHandler(sender: UIBarButtonItem) {
        
        let dataValid = form.validateAll()
        let heightVal =  self.form.rowByTag("heightTextField")!.baseValue as? Int
        let weightVal =  self.form.rowByTag("weightTextField")!.baseValue as? Int
        print("typeeee" + (heightVal?.description)!)

        
        
        if(dataValid){
            
            let dob = form.rowByTag("dateOfBirthTextField")!.baseValue as! NSDate
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dobStringFormat = dateFormatter.stringFromDate(dob)
            
            let localDB = NSUserDefaults.standardUserDefaults()
            let user_email = localDB.objectForKey("user_email") as? String
            let user_id: String = user_email!
            
            let first_name: String = form.rowByTag("firstNameTextField")!.baseValue as! String
            let last_name: String = form.rowByTag("lastNameTextField")!.baseValue as! String
            let weight: Int = form.rowByTag("weightTextField")!.baseValue as! Int
            let height: Int = form.rowByTag("heightTextField")!.baseValue as! Int
            let gender: String = String(form.rowByTag("genderTextField")!.baseValue!)
            let injuries: String = String(form.rowByTag("injuriesTextField")!.baseValue!)
            let email = user_email
            let contact: String = String(form.rowByTag("mobileNoTextField")!.baseValue!)
            
            let genderValue: String
            if gender == "Male" {
                genderValue = "M"
            }else {
                genderValue = "F"
            }
            
            let userBasicInfo: NSDictionary = [
                "user_id": user_id,
                "first_name": first_name,
                "last_name": last_name,
                "weight": weight,
                "height": height,
                "dob": dobStringFormat,
                "gender": genderValue,
                "email": email!,
                "contact_number": contact,
                "injuries": injuries
            ]
            
            let postEndpoint: String = "http://ec2-54-67-63-89.us-west-1.compute.amazonaws.com:8080/v1/users/\(user_id)"
            
            let url = NSURL(string: postEndpoint)!
            let session = NSURLSession.sharedSession()
            let postParams : NSDictionary = userBasicInfo
            
            // Create the request
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "PUT"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            do {
                request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(postParams, options: NSJSONWritingOptions())
                print(postParams)
            } catch {
                print("bad things happened")
            }
            
            // Make the POST call and handle it in a completion handler
            session.dataTaskWithRequest(request, completionHandler: { ( data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
                // Make sure we get an OK response
                guard let realResponse = response as? NSHTTPURLResponse where
                    realResponse.statusCode >= 200 && realResponse.statusCode < 300 else {
                        print("Not a 200 response")
                        return
                }
                
                // Read the JSON
                if let postString = NSString(data:data!, encoding: NSUTF8StringEncoding) as? String {
                    // Print what we got from the call
                    print("PUT Success")
                    
                }
                
            }).resume()
            
            navigationController!.popViewControllerAnimated(true)
        }
        
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        let dataValid = form.validateAll()
        
        if(dataValid && self.form.rowByTag("weightTextField")!.baseValue != nil
            && self.form.rowByTag("heightTextField")!.baseValue != nil ){
            
            return true
            
        }
        return false
    }
    
    
    
}
