//
//  UserProfileViewController.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/13/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka
import SwiftValidator

class UserProfileViewController: FormViewController {
    
    var heightValue = 0
    var weightValue = 0
    var dobValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let profileID = NSUserDefaults.standardUserDefaults().objectForKey("fb_id") as! String
        //load_image("https://graph.facebook.com/\(profileID)/picture")
        
        
        form =
            
            Section()
            
            +++ Section()
            
            +++ Section("User Profile")
            
            <<< SVTextRow() {
                $0.tag = "firstNameTextField"
                $0.title =  "First Name"
                $0.placeholder = "First Name"
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
                
            }
            
            <<< SVTextRow() {
                $0.tag = "lastNameTextField"
                $0.title =  "Last Name"
                $0.placeholder = "Last Name"
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
            }
            
            <<< DateRow() {
                $0.tag = "dateOfBirthTextField"
                $0.value = NSDate()
                $0.title = "Date of Birth"
                
                }
                .cellUpdate { cell, row in
                    cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
            
            
            <<< SegmentedRow<String>() {
                $0.tag = "genderTextField"
                $0.title = "Gender"
                $0.options = ["Male", "Female"]
                $0.value = "Male"
                
            }
            
            <<< SVPhoneRow() {
                $0.tag = "mobileNoTextField"
                $0.title = "Mobile No"
                $0.placeholder = "Mobile No"
                $0.rules = [RequiredRule(), PhoneNumberRule()]
                $0.autoValidation = false
                
            }
            
            <<< SVEmailRow() {
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
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
                
            }
            
            <<< SVIntRow() {
                $0.title = "Weight"
                $0.tag = "weightTextField"
                $0.placeholder = "Weight (in kgs)"
                $0.rules = [RequiredRule()]
                $0.autoValidation = true
            }
            
            
            <<< SVTextRow() {
                $0.tag = "injuriesTextField"
                $0.title =  "Injuries, if any"
//                $0.placeholder = "(optional)"
                $0.value = "None"
                $0.rules = [RequiredRule()]
                $0.autoValidation = false
            }
            
            // +++ Section()
            
            
            <<< ButtonRow("Set Preferences") {
                $0.title = $0.tag
                
                
                }
                .cellUpdate { cell, row in
                    cell.textLabel?.textColor = UIColor.blueColor()
                    cell.textLabel?.textAlignment = NSTextAlignment.Left
                }
                .onCellSelection({ (cell, row) in
                    cell.textLabel?.textAlignment = NSTextAlignment.Left                    
                    let dataValid = self.form.validateAll()
                    
                    if(dataValid && self.form.rowByTag("weightTextField")!.baseValue != nil
                        && self.form.rowByTag("heightTextField")!.baseValue != nil){
                        self.performSegueWithIdentifier("preferencesSegue", sender: self)
                        row.disabled = false
                        
                    }
                    row.disabled = true
                    //                if(dataValid){
                    //                    $0.presentationMode = .SegueName(segueName: "preferencesSegue", completionCallback: nil)
                    //
                    //                }else {
                    //                    $0.disabled = true
                    //                }
                    
                })
            +++ Section()
        
        
    }
    
    
    func load_image(urlString:String)
    {
        let imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request){
            (data, response, error) -> Void in
            
            if (error == nil && data != nil)
            {
                func display_image()
                {
                    let image = UIImage(data: data!)
                    let imageView = UIImageView(image: image!)
                    imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
                    imageView.layer.cornerRadius = 25;
                    imageView.layer.masksToBounds = true;
                    
                    self.view.addSubview(imageView)
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }
    
    // Do any additional setup after loading the view.
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let localDB = NSUserDefaults.standardUserDefaults()
        let user_email = localDB.objectForKey("user_email") as? String
        
        let dobDateFormat = form.rowByTag("dateOfBirthTextField")!.baseValue as! NSDate
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dobStringFormat = dateFormatter.stringFromDate(dobDateFormat)
        
        let user_id = user_email
        let first_name: String = form.rowByTag("firstNameTextField")!.baseValue as! String
        let last_name: String = form.rowByTag("lastNameTextField")!.baseValue as! String
        let weight: Int = form.rowByTag("weightTextField")!.baseValue as! Int
        let height: Int = form.rowByTag("heightTextField")!.baseValue as! Int
        let dob: String = dobStringFormat
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
            "user_id": user_id!,
            "first_name": first_name,
            "last_name": last_name,
            "weight": weight,
            "height": height,
            "dob": dob,
            "gender": genderValue,
            "email": email!,
            "contact_number": contact,
            "injuries": injuries
        ]
        
        localDB.setObject(userBasicInfo, forKey: "userBasicInfo")
        localDB.setObject(" ", forKey: "googleUserName")
        
    }
    
    
}

