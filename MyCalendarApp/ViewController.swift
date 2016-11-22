//
//  ViewController.swift
//  MyCalendarApp
//
//  Created by Bill McCoy on 11/17/16.
//  Copyright © 2016 WellSpan Health. All rights reserved.
//

import UIKit
import FSCalendar
import Alamofire

class MyCustomCell: UITableViewCell {
    
    @IBOutlet weak var ApptTimeLabel: UILabel!

}

struct Time {
    
    let start: TimeInterval
    let end: TimeInterval
    let interval: TimeInterval
    
    init(start: TimeInterval, interval: TimeInterval, end: TimeInterval) {
        self.start = start
        self.interval = interval
        self.end = end
    }
    
    init(startHour: TimeInterval, intervalMinutes: TimeInterval, endHour: TimeInterval) {
        self.start = startHour * 60 * 60
        self.end = endHour * 60 * 60
        self.interval = intervalMinutes * 60
    }
    
    var timeRepresentations: [String] {
        let dateComponentFormatter = DateComponentsFormatter()
        dateComponentFormatter.unitsStyle = .positional
        dateComponentFormatter.allowedUnits = [.minute, .hour]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        var dateComponent = DateComponents()
        return timeIntervals.map { timeInterval in
            dateComponent.second = Int(timeInterval)
            return dateComponentFormatter.string(from: dateComponent as DateComponents)!
        }
    }
    
    var timeIntervals: [TimeInterval]{
        return Array(stride(from:start, through: end, by: interval))
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDataSource, FSCalendarDelegate {

    var openSlots: [String] = []
    var selectedTime: String = ""
    var selectedDate: Date?
    
    @IBOutlet weak var ApptTable: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // get a reference to the second view controller
        let secondViewController = segue.destination as! ScheduleApptView
        secondViewController.selectedTime = selectedTime
        secondViewController.selectedDate = selectedDate
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
       
        let indexPath = ApptTable.indexPathForSelectedRow
        let currentCell = tableView.cellForRow(at: indexPath!) as! MyCustomCell
        selectedTime = currentCell.ApptTimeLabel.text!
        
        self.performSegue(withIdentifier: "ShowApptScheduler", sender: self)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.openSlots.count)
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MyCustomCell = self.ApptTable.dequeueReusableCell(withIdentifier: "CustomCell") as! MyCustomCell
        cell.ApptTimeLabel.text = openSlots[indexPath.row]
        
        return cell
    }
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    fileprivate let gregorian: Calendar! = Calendar(identifier:Calendar.Identifier.gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let cal = Calendar(identifier: .gregorian)
        let newDate = cal.startOfDay(for: date)
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]
        self.calendar.select(newDate)
        self.calendar.scope = .week
        self.calendar.scopeGesture.isEnabled = true
        self.ApptTable.dataSource = self
        self.ApptTable.delegate = self
        
        
        getAppointments()
        //FillSlotsArray()
        //selectedDate = Date()

        
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2015/01/01")!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.formatter.date(from: "2021/10/31")!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        //let day: Int! = self.gregorian.component(.day, from: date)
        return 0//day % 5 == 0 ? day/5 : 0;
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        NSLog("change page to \(self.formatter.string(from: calendar.currentPage))")
    }
    
    func FillSlotsArray(){
        let time = Time(startHour: 8, intervalMinutes: 30, endHour: 18)
        let array = time.timeRepresentations
        let dateFormatter = DateFormatter()
        
        self.openSlots.removeAll()
        
        
        for twelve in array {
            dateFormatter.dateFormat = "H:mm"
            let k: Int = Int(arc4random_uniform(2))
            if let date12 = dateFormatter.date(from: twelve) {
                dateFormatter.dateFormat = "h:mm a"
                let date22 = dateFormatter.string(from: date12)
                if k == 1{
                    self.openSlots.append(date22)
                }
            } else {
                // oops, error while converting the string
            }
            
        }
        ApptTable.reloadData()
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        
        //selectedDate = date
        //FillSlotsArray()
       
    }
    
    func getAppointments(){
        let URL = "http://appointmentslotsapi.azurewebsites.net/api/Appointment/GetAppointments"

        Alamofire.request(URL).responseArray { (response: DataResponse<[Appt]>) in
            
            let appts = response.result.value
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if let appts = appts {
                for appt in appts {
                    print(dateFormatter.date(from: appt.StartTime!)!)
                    //print(appt.StartTime!)
                    //print(appt.EndTime!)
                }
            }
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        //let day: Int! = self.gregorian.component(.day, from: date)
        return nil //[13,24].contains(day) ? UIImage(named: "icon_cat") : nil
    }


}

