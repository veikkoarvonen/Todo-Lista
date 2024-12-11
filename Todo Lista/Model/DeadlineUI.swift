//
//  DeadlineUI.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

struct DeadlineUI {
    
    func getMonthDateArray(from date: Date) -> [Int] {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: date)
        
        var firstDayComps = DateComponents()
        firstDayComps.year = comps.year
        firstDayComps.month = comps.month
        firstDayComps.day = 1
        
        let firstDay = cal.date(from: firstDayComps)!
        let range = cal.range(of: .day, in: .month, for: firstDay)!
        
        return Array(range)
    }
    
    func getWeekdayStartingIndex(from date: Date) -> Int {
        let cal = Calendar.current
        let comps = cal.dateComponents([.year, .month], from: date)
        
        var firstDayComps = DateComponents()
        firstDayComps.year = comps.year
        firstDayComps.month = comps.month
        firstDayComps.day = 1
        
        let firstDay = cal.date(from: firstDayComps)!
        let weekdayIndex = cal.dateComponents([.weekday], from: firstDay).weekday!
        
        var formattedWeekdayIndex: Int {
            switch weekdayIndex {
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
        
        return formattedWeekdayIndex
    }
    
    func getNumberOfWeeksInMonth(dayRange: [Int], startingDayIndex: Int) -> Int {
        
        var startingIndexForDay = startingDayIndex
        var numberOfWeeks: Int = 1
        
        if startingIndexForDay == 0 {
            numberOfWeeks = 0
        }
        
        var moe: [Int] = []
        
        for _ in dayRange {
            
            if startingIndexForDay == 0 {
                numberOfWeeks += 1
            }
            
            moe.append(startingIndexForDay)
            if startingIndexForDay == 6 {
                startingIndexForDay = 0
            } else {
                startingIndexForDay += 1
            }
        }
        
        return numberOfWeeks
        
    }
    
}
