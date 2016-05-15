//
//  Goal.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class Goal {
    
    // MARK: Properties
    
    var name: String
    var end_datetime: String
    var start_datetime: String
    var id: String
    var target_burn_calories: Int
    var target_distance: Int
    var user_id: String
    
    init?(name: String, end_datetime: String, start_datetime: String, id: String, target_burn_calories: Int, target_distance: Int, user_id: String) {
        // Initialize stored properties.
        self.name = name
        self.end_datetime = end_datetime
        self.start_datetime = start_datetime
        self.id = id
        self.target_burn_calories = target_burn_calories
        self.target_distance = target_distance
        self.user_id = user_id
        
        // Initialization should fail if there is no name
        if name.isEmpty {
            return nil
        }
    }

}
