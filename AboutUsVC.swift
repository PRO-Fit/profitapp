//
//  AboutUsVC.swift
//  ProFit
//
//  Created by Vijesh Jain on 4/23/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit
import Eureka

class AboutUsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindAboutUsToSettingsHome(sender: UIStoryboardSegue) {
        
        
    }
    
    @IBAction func onBackClick(sender: UIBarButtonItem) {
        //dismissViewControllerAnimated(true, completion: nil)
        navigationController!.popViewControllerAnimated(true)

    }
}
