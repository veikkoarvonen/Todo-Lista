//
//  DeadlineUI.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

struct DeadlineUI {
    
    func createLeftButton() -> UIButton {
        let leftButton = UIButton(type: .system)
        let leftArrowImage = UIImage(systemName: "arrow.left")
        leftButton.setImage(leftArrowImage, for: .normal)
        leftButton.tintColor = UIColor(named: C.Colors.brandColor)
        return leftButton
    }
    
    func createRightButton() -> UIButton {
        let rightButton = UIButton(type: .system)
        let rightArrowImage = UIImage(systemName: "arrow.right")
        rightButton.setImage(rightArrowImage, for: .normal)
        rightButton.tintColor = UIColor(named: C.Colors.brandColor)
        return rightButton
    }
    
    func createMonthLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = .clear
        label.text = "Syyskuu 2024"
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont(name: "Optima", size: 16)
        return label
    }
    
    func createWeekdayStack() -> UIStackView {
        let weekdays = ["Ma","Ti","Ke","To","Pe","La","Su"]
        
        let stack = UIStackView()
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually // This ensures that each subview gets equal width
        stack.alignment = .center // Aligns all subviews in the center vertically
        
        // Loop through weekdays and create labels, then add them to the stack
        for day in weekdays {
            let label = UILabel()
            label.text = day
            label.textAlignment = .center
            label.font = UIFont(name: "optima", size: 12)
            stack.addArrangedSubview(label)
        }
        return stack
    }
    
    func getMonthDates(from date: Date) -> [MonthDay] {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: date)
        
        var firstDayComps = DateComponents()
        firstDayComps.year = comps.year
        firstDayComps.month = comps.month
        firstDayComps.day = 1
        
        let firstDay = cal.date(from: firstDayComps)!
        let range = cal.range(of: .day, in: .month, for: firstDay)!
        
        var monthDays: [MonthDay] = []
        
        //get first week's weeknumber (subtract one if first day is sunday to match Finnish calendar)
        var firstWeekIndex: Int {
            let firstDayWeekDay = cal.dateComponents([.weekday], from: firstDay)
            if firstDayWeekDay.weekday != 1 {
                return cal.dateComponents([.weekOfYear], from: firstDay).weekOfYear!
            } else {
                return cal.dateComponents([.weekOfYear], from: firstDay).weekOfYear! - 1
            }
        }
        
        for i in range {
            
            //get date
            let date = cal.date(byAdding: .day, value: i - 1, to: firstDay)!
            let comps = cal.dateComponents([.month, .weekday, .weekOfYear, .day], from: date)
            
            //get date string
            let dateString = "\(comps.day!)"
            
            //get weekdayIndex
            var weekdayIndex: Int {
                switch comps.weekday {
                case 1: return 6 //sunday
                case 2: return 0 //monday
                case 3: return 1 //tuesday
                case 4: return 2 //wednesday
                case 5: return 3 //thrusday
                case 6: return 4 //friday
                case 7: return 5 //saturday
                default: return 1
                }
            }
            
            //get weekIndex
            var weekIndex: Int {
                //replace 1 with 53 in december
                if comps.month == 12 && comps.weekOfYear == 1 {
                    if weekdayIndex == 6 {
                        return 53 - firstWeekIndex - 1
                    } else {
                        return 53 - firstWeekIndex
                    }
                } else {
                    if weekdayIndex == 6 {
                        return comps.weekOfYear! - firstWeekIndex - 1
                    } else {
                        return comps.weekOfYear! - firstWeekIndex
                    }
                }
            }
            
            
            
            let newDate = MonthDay(week: weekIndex, weekday: weekdayIndex, dateString: dateString, date: date)
            monthDays.append(newDate)
        }
        return monthDays
        
    }

}





struct MonthDay {
    var week: Int
    var weekday: Int
    var dateString: String
    var date: Date
}
