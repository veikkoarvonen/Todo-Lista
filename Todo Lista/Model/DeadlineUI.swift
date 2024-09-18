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
    
    func createMonthStack(year: Int, month: Int) -> [DeadlineCalendarDay] {
        
        //Determine month's first date and amount of days
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.year = year
        comps.month = month
        comps.day = 1
        
        guard let firstDay = calendar.date(from: comps) else { return [] }
        guard let range = calendar.range(of: .day, in: .month, for: firstDay) else { return [] }
        
        let weekday = calendar.component(.weekday, from: firstDay)
        let numberOfDays = range.count

        //Create an array of the month's dates
        var currentDate = firstDay
        var dates: [Date] = []
        for _ in 0..<numberOfDays {
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        //Generate an array of custom structure, with week & day indexes
        var formattedDates: [DeadlineCalendarDay] = []
        
        //Determine first week's number and subtract one if first day is sunday
        var firstWeekIndex = calendar.component(.weekOfYear, from: firstDay)
        if calendar.component(.weekday, from: firstDay) == 1 {
            firstWeekIndex -= 1
        }
        
        //Create an array of custom structures
        for date in dates {
            let weekday = calendar.component(.weekday, from: date)
            var weekdayIndex: Int {
                switch weekday {
                case 1: return 6
                case 2: return 0
                case 3: return 1
                case 4: return 2
                case 5: return 3
                case 6: return 4
                case 7: return 5
                default: return 0
                }
            }
            var week = calendar.component(.weekOfYear, from: date)
            week -= firstWeekIndex
            if weekday == 1 {
                week -= 1
            }
            let day = calendar.component(.day, from: date)
            let newDate = DeadlineCalendarDay(weekday: weekdayIndex, week: week, day: day)
            print(newDate)
            formattedDates.append(newDate)
        }
        
        return formattedDates
    }
    
    func createDayLabels(days: [DeadlineCalendarDay]) -> [UILabel] {
        
        var labels: [UILabel] = []
        for i in 0..<days.count {
            let label = UILabel()
            label.text = "\(days[i].day)"
            label.textAlignment = .center
            label.font = UIFont(name: "optima", size: 15)
            labels.append(label)
        }
        return labels
    }

    func getFrames(days: [DeadlineCalendarDay], width: CGFloat, heigth: CGFloat) -> [CGRect] {
        let minWeek = days.min(by: { $0.week < $1.week })!.week
        let maxWeek = days.max(by: { $0.week < $1.week })!.week
        let numberOfWeeksForSheet = maxWeek - minWeek + 1
        
        var frames: [CGRect] = []
        
        for day in days {
            let x: CGFloat = CGFloat(day.weekday) * (width / 7)
            let y: CGFloat = CGFloat(day.week) * (heigth / CGFloat(numberOfWeeksForSheet)) + 75
            let w = width / 7
            let h = heigth / CGFloat(numberOfWeeksForSheet)
            frames.append(CGRect(x: x, y: y, width: w, height: h))
        }
        
        return frames
        
    }
}



struct DeadlineCalendarDay {
    var weekday: Int
    var week: Int
    var day: Int
}
