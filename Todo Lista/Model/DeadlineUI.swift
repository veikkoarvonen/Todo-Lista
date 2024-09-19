//
//  DeadlineUI.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

struct DeadlineUI {
    
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
