//
//  Notification.swift
//  ProFit
//
//  Created by Vijesh Jain on 5/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class Notification {
    // MARK: Properties
    
    var id: String
    var sessionName: String
    var workout_type_id: Int
    var start_datetime: String
    var end_datetime: String
    var session_feedback_id: String
    var session_status: String
    var type: String
    
    init?(id: String, sessionName: String, workout_type_id: Int, start_datetime: String, end_datetime: String, session_feedback_id: String, session_status: String, type: String) {
        // Initialize stored properties.
        self.id = id
        self.sessionName = sessionName
        self.workout_type_id = workout_type_id
        self.start_datetime = start_datetime
        self.end_datetime = end_datetime
        self.session_feedback_id = session_feedback_id
        self.session_status = session_status
        self.type = type
        
        // Initialization should fail if there is no workout id
        if start_datetime.isEmpty {
            return nil
        }
    }
    
    
}