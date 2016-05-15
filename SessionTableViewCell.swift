//
//  GoalTableViewCell.swift
//  ProFit
//
//  Created by Saumil Dharia on 4/2/16.
//  Copyright © 2016 Allen. All rights reserved.
//

import UIKit

class SessionTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var sessionName: UILabel!
    @IBOutlet weak var startDateTimeLabel: UILabel!
    @IBOutlet weak var endDateTimeLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
