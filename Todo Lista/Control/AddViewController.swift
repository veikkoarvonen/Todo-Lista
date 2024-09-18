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
    var deadlineCalendarView = UIView()
    var monthViews = [UIView]()
    var deadlineDayLabels = [UILabel]()
    var monthStringLabel = UILabel()
    var hasSetUI = false
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var deadlineSwitchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetUI {
            setDeadlineView()
            hasSetUI = true
        }
    }
    
    @IBAction func deadlineSwitchPressed(_ sender: UISwitch) {
    }
    
    @objc func leftArrowTapped() {
        let newDate = Calendar.current.date(byAdding: .month, value: -1, to: deadlineCalendarDate)!
        deadlineCalendarDate = newDate
        updateMonthLabelText()
        print(deadlineCalendarDate)
        UIView.animate(withDuration: 0.3, animations: {
            for monthView in self.monthViews {
                monthView.center.x += self.view.frame.width
            }
        }, completion: { finished in
            if finished {
                self.updateMonthViews()
            }
        })
    }
    
    @objc func rightArrowTapped() {
        let newDate = Calendar.current.date(byAdding: .month, value: 1, to: deadlineCalendarDate)!
        deadlineCalendarDate = newDate
        updateMonthLabelText()
        print(deadlineCalendarDate)
        UIView.animate(withDuration: 0.3, animations: {
            for monthView in self.monthViews {
                monthView.center.x -= self.view.frame.width
            }
        }, completion: { finished in
            if finished {
                self.updateMonthViews()
            }
        })
    }
    
    
    
}


extension AddViewController {
   
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
        monthStringLabel.text = "\(monthString) \(yearString)"
    }
    
    
//MARK: - Set Deadline selection view programatically
    
    private func setDeadlineView() {
        
        let deadlineViewY = deadlineSwitchView.center.y + deadlineSwitchView.frame.height / 2 + view.safeAreaInsets.top
        
        let deadlineView = UIView()
        deadlineView.backgroundColor = .clear
        view.addSubview(deadlineView)
        deadlineView.frame = CGRect(x: 0, y: deadlineViewY, width: view.frame.width, height: 75)
        deadlineCalendarView = deadlineView
        
        
        let buttonSize: CGFloat = 50
        let stackHeight: CGFloat = 25
        
        //Create left arrow button
        let leftButton = dlUI.createLeftButton()
        leftButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        leftButton.addTarget(self, action: #selector(leftArrowTapped), for: .touchUpInside)
        self.deadlineCalendarView.addSubview(leftButton)
        
        //Create right button
        let rightButton = dlUI.createRightButton()
        let x = view.frame.width - buttonSize
        rightButton.frame = CGRect(x: x, y: 0, width: buttonSize, height: buttonSize)
        rightButton.addTarget(self, action: #selector(rightArrowTapped), for: .touchUpInside)
        self.deadlineCalendarView.addSubview(rightButton)
        
        //Create month label
        let monthLabel = dlUI.createMonthLabel()
        monthLabel.frame = CGRect(x: buttonSize, y: 0, width: view.frame.width - buttonSize * 2, height: buttonSize)
        self.deadlineCalendarView.addSubview(monthLabel)
        monthStringLabel = monthLabel
        
        
        //Create weekday stack
        let stack = dlUI.createWeekdayStack()
        stack.frame = CGRect(x: 0, y: buttonSize, width: view.frame.width, height: stackHeight)
        self.deadlineCalendarView.addSubview(stack)
        
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
            var y = CGFloat(d.week) * (height / CGFloat(numberOfWeeks))
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
