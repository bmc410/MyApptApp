//
//  ScheduleApptView.swift
//  MyCalendarApp
//
//  Created by Bill McCoy on 11/18/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//

import UIKit

class ScheduleApptView: UIViewController {

    var selectedTime: String = ""
    var selectedDate: Date?
    
    @IBOutlet weak var DateTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        let dateString = formatter.string(from: selectedDate!)
        DateTimeLabel.text = "You are scheduling an appointment for " + dateString + " at " + selectedTime
        
    }

}
