//
//  ArticleTableViewCell.swift
//  TabbarApp
//
//  Created by Allen on 16/2/5.
//  Copyright © 2016年 Allen. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeRangeText: UILabel!
    @IBOutlet weak var feedType: UILabel!
    @IBOutlet weak var recoDateText: UILabel!
    @IBOutlet weak var activityType: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
