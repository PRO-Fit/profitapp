//
//  UserProfileViewController.swift
//  ProFIt
//
//  Created by Vijesh Jain on 3/27/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka


class UserProfileViewController_old: FormViewController  {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg_image.jpg")!)
        profileImage.layer.cornerRadius = 25;
        profileImage.layer.masksToBounds = true;
        let profileID = NSUserDefaults.standardUserDefaults().objectForKey("fb_id") as! String
        load_image("https://graph.facebook.com/\(profileID)/picture")
        emailTextField.text = NSUserDefaults.standardUserDefaults().objectForKey("user_email") as? String
        
        

    }
    
    var genderElements = ["Male", "Female"]

    @IBOutlet weak var fnameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dobTextField: UITextField!
    @IBOutlet weak var lnameTextField: UITextField!
    @IBOutlet weak var injuriesTextField: UITextField!
    
    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.stringFromDate(sender.date)
        dobTextField.text = strDate
    }
    
    @IBAction func dateOfBirthPickerAction(sender: UITextField) {
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.Date
        
        sender.inputView = datePickerView         
        
        datePickerView.addTarget(self, action: #selector(UserProfileViewController_old.datePickerValueChanged), forControlEvents: UIControlEvents.ValueChanged)
    }
   
    
    func numberOfRowsInComponent(component: Int) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        genderTextField.text = genderElements[row]
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return genderElements[row]
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return genderElements.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        return false
    }

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
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
                    self.profileImage.image = UIImage(data: data!)
                }
                
                dispatch_async(dispatch_get_main_queue(), display_image)
            }
            
        }
        
        task.resume()
    }


    @IBAction func onClickNext(sender: UIButton) {
        let localDB = NSUserDefaults.standardUserDefaults()
        
        let user_id = localDB.objectForKey("user_email")
        let first_name: String = fnameTextField.text!
        let last_name: String = lnameTextField.text!
        let weight: String = weightTextField.text!
        let height: String = heightTextField.text!
        let dob: String = dobTextField.text!
        let gender: String
        if genderTextField.text == "Male" {
                gender = "M"
        }else {
            gender = "F"
        }
        
        var injuries: String = ""
        if injuriesTextField.text == "" {
            injuries = ""
        } else {
            injuries = injuriesTextField.text!
        }
        
        let email = localDB.objectForKey("user_email") as! String
        let contact: String = mobileTextField.text!
        
        let userData: NSDictionary = [
            "user_id": user_id!,
            "first_name": first_name,
            "last_name": last_name,
            "weight": weight,
            "height": height,
            "dob": dob,
            "gender": gender,
            "email": email,
            "contact_number": contact,
            "injuries": injuries
        ]
        
        localDB.setObject(userData, forKey: "userBasicInfo")

        
    }


}
