//
//  Goal.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class BlockSession {
    
    // MARK: Properties
    var id: Int
    var startTime: String
    var endTime: String
    var selectedDay: String
    
    
    init?(id: Int, startTime: String, endTime: String, selectedDay: String) {
        
        self.id = id        
        self.startTime = startTime
        self.endTime = endTime
        self.selectedDay = selectedDay
        
    }
    
}
