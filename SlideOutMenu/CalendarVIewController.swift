//
//  CalendarVIewController.swift
//  Example-Swift
//
//  Created by Saumil Dharia on 3/19/16.
//  Copyright © 2016 DC. All rights reserved.
//

import Foundation

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate{
    
    var sessions = [Session]()
    var count: Int = 0
    var userSessions = [String: [Session]]()
    var userSessionsCount = [String: Int]()
    
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateSessions()
        //getUserSessions()
        calendar.scrollDirection = .Vertical
        calendar.appearance.caseOptions = [.HeaderUsesUpperCase,.WeekdayUsesUpperCase]
        calendar.selectDate(calendar.dateWithYear(2015, month: 10, day: 10))
        calendar.selectDate(calendar.today)
        //calendar.allowsMultipleSelection = true
        
        // Uncomment this to test month->week and week->month transition
        
        /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Week, animated: true)
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
         self.calendar.setScope(.Month, animated: true)
         }
         }*/
        
        
    }
    
    
    func minimumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2015, month: 1, day: 1)
    }
    
    func maximumDateForCalendar(calendar: FSCalendar) -> NSDate {
        return calendar.dateWithYear(2016, month: 10, day: 31)
    }
    
    func calendar(calendar: FSCalendar, numberOfEventsForDate date: NSDate) -> Int {
        //let day = calendar.dayOfDate(date)
        let day = userSessionsCount[calendar.stringFromDate(date)]
        if (day != nil){
            return day!
        }
        else
        {
            return 0
        }
    }
    
    func calendarCurrentPageDidChange(calendar: FSCalendar) {
        //NSLog("change page to \(calendar.stringFromDate(calendar.currentPage))")
    }
    
    func calendar(calendar: FSCalendar, didSelectDate date: NSDate) {
        //NSLog("calendar did select date \(calendar.stringFromDate(date))")
        var sessions1 = [Session]()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("SessionTableView") as! SessionTableViewController
        if (userSessions[calendar.stringFromDate(date)] != nil){
            sessions1 = userSessions[calendar.stringFromDate(date)]!
        }
        
        viewController.sessions = sessions1
        navigationController?.showViewController(viewController, sender: true)
    }
    
    func calendar(calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(calendar: FSCalendar, imageForDate date: NSDate) -> UIImage? {
        return [13,24].containsObject(calendar.dayOfDate(date)) ? UIImage(named: "icon_cat") : nil
    }
    
}