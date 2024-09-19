//
//  AddViewController.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

class AddViewController: UIViewController {
    
    let dlUI = DeadlineUI()
    var deadlineCalendarDate = Date()
    var monthViews = [UIView]()
    var deadlineDayLabels = [UILabel]()
    var newDeadlineDayLabels = [UILabel]()
    var hasSetUI = false
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var deadlineSwitchView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var deadlineTimePicker: UIDatePicker!
    @IBOutlet weak var monthTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetUI {
            setDeadlineCalendar(for: deadlineCalendarDate, location: 0)
            hasSetUI = true
        }
    }
    
    @IBAction func leftArrowTapped(_ sender: UIButton) {
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: deadlineCalendarDate)
        deadlineCalendarDate = newDate!
        moveCalendarLeft()
        updateMonthLabelText()
        print(deadlineCalendarDate)
    }
    
    @IBAction func rightArrowTapped(_ sender: UIButton) {
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: deadlineCalendarDate)
        deadlineCalendarDate = newDate!
        moveCalendarRight()
        updateMonthLabelText()
        print(deadlineCalendarDate)
    }
    
    
    @IBAction func deadlineSwitchPressed(_ sender: UISwitch) {
        
    }
    
    
}


extension AddViewController {
    
    private func setDeadlineCalendar(for date: Date, location: Int) {
        
        let days = dlUI.getMonthDates(from: date)
        let maxWeek = days.max(by: { $0.week < $1.week })!.week
        let numberOfWeeks = maxWeek + 1
        
        for i in 0..<days.count {
            let d = days[i]
            
            let label = UILabel()
            label.text = d.dateString
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "optima", size: 12)
            calendarView.addSubview(label)
            
            if location == 0 {
                deadlineDayLabels.append(label)
            } else {
                newDeadlineDayLabels.append(label)
            }
            
            
            let width = calendarView.frame.width
            let height = calendarView.frame.height
            let x = CGFloat(d.weekday) * (width / 7)
            let y = CGFloat(d.week) * (height / CGFloat(numberOfWeeks))
            let w = width / 7
            let h = height / CGFloat(numberOfWeeks)
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            label.center.x += (view.frame.width * CGFloat(location))
            
        }
        
    }
    
    private func moveCalendarLeft() {
        
        setDeadlineCalendar(for: deadlineCalendarDate, location: -1)
        UIView.animate(withDuration: 0.3, animations: {
            for label in self.deadlineDayLabels {
                label.center.x += self.view.frame.width
            }
            for label in self.newDeadlineDayLabels {
                label.center.x += self.view.frame.width
            }
        }, completion: { finished in
            if finished {
                for label in self.deadlineDayLabels {
                    label.removeFromSuperview()
                }
                self.deadlineDayLabels = self.newDeadlineDayLabels
                self.newDeadlineDayLabels.removeAll()
            }
        })
    }
    
    private func moveCalendarRight() {
        
        setDeadlineCalendar(for: deadlineCalendarDate, location: 1)
        UIView.animate(withDuration: 0.3, animations: {
            for label in self.deadlineDayLabels {
                label.center.x -= self.view.frame.width
            }
            for label in self.newDeadlineDayLabels {
                label.center.x -= self.view.frame.width
            }
        }, completion: { finished in
            if finished {
                for label in self.deadlineDayLabels {
                    label.removeFromSuperview()
                }
                self.deadlineDayLabels = self.newDeadlineDayLabels
                self.newDeadlineDayLabels.removeAll()
            }
        })
    }
    
   
//MARK: - Update labeltext
    
    private func updateMonthLabelText() {
        let comps = Calendar.current.dateComponents([.month, .year], from: deadlineCalendarDate)
        
        var monthString: String {
            switch comps.month {
            case 1: return "Tammikuu"
            case 2: return "Helmikuu"
            case 3: return "Maaliskuu"
            case 4: return "Huhtikuu"
            case 5: return "Toukokuu"    
            case 6: return "Kesäkuu"
            case 7: return "Heinäkuu"
            case 8: return "Elokuu"
            case 9: return "Syyskuu"
            case 10: return "Lokakuu"
            case 11: return "Marraskuu"
            case 12: return "Joulukuu"
            default: return "Unknown"
            }
        }
        
        let yearString = "\(comps.year!)"
        monthTextLabel.text = "\(monthString) \(yearString)"
    }
    
    
//MARK: - Set Deadline selection view programatically
    
    private func setDeadlineView() {
        
        //create monthViews
        updateMonthViews()
        
        
    }
    
    private func updateMonthViews() {
        for monthWiew in monthViews {
            monthWiew.removeFromSuperview()
        }
        monthViews.removeAll()
        let y = deadlineSwitchView.center.y + deadlineSwitchView.frame.height / 2 + view.safeAreaInsets.top
        for i in -1...1 {
            let date = Calendar.current.date(byAdding: .month, value: i, to: deadlineCalendarDate)!
            createMonthView(yCord: y + 75, from: date, location: i)
        }
    }
    
    private func createMonthView(yCord: CGFloat, from date: Date, location: Int) {
        deadlineDayLabels.removeAll()
        let monthView = UIView()
        monthView.backgroundColor = .clear
        view.addSubview(monthView)
        monthView.frame = CGRect(x: 0, y: yCord, width: view.frame.width, height: 225)
        
        let viewWidth = view.frame.width
        var centerX: CGFloat {
            switch location {
            case -1: return viewWidth / 2 - viewWidth
            case 0: return viewWidth / 2
            case 1: return viewWidth / 2 + viewWidth
            default: return viewWidth / 2
            }
        }
        monthView.center.x = centerX
        
        let monthDates = dlUI.getMonthDates(from: date)
        let maxWeek = monthDates.max(by: { $0.week < $1.week })!.week
        let numberOfWeeks = maxWeek + 1
        
        for i in 0..<monthDates.count {
            let d = monthDates[i]
            let label = UILabel()
            label.text = d.dateString
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont(name: "optima", size: 12)
            monthView.addSubview(label)
            deadlineDayLabels.append(label)
       
            
            let width = monthView.frame.width
            let height = monthView.frame.height
            let x = CGFloat(d.weekday) * (width / 7)
            let y = CGFloat(d.week) * (height / CGFloat(numberOfWeeks))
            let w = width / 7
            let h = height / CGFloat(numberOfWeeks)
            
            label.frame = CGRect(x: x, y: y, width: w, height: h)
            
            let comp = Calendar.current.dateComponents([.month, .weekday], from: d.date)
            if comp.month == 12 {
                //print("Date: \(d.dateString): x: \(x), y: \(y), weeknumber: \()")
            }
            
        }
        monthViews.append(monthView)
    }
}
