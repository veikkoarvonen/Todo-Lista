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
    var hasSetUI = false
    var deadlineDayLabels = [UILabel]()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var deadlineSwitchView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dlUI.getMonthDates(from: deadlineCalendarDate)
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
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: deadlineCalendarDate) {
            deadlineCalendarDate = newDate
        }
        let components = Calendar.current.dateComponents([.year, .month], from: deadlineCalendarDate)
        if let year = components.year, let month = components.month {
            print("Year: \(year), Month: \(month)")
            dlUI.createMonthStack(year: year, month: month)
        }
       
    }
    
    @objc func rightArrowTapped() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: deadlineCalendarDate) {
            deadlineCalendarDate = newDate
        }
        let components = Calendar.current.dateComponents([.year, .month], from: deadlineCalendarDate)
        if let year = components.year, let month = components.month {
            print("Year: \(year), Month: \(month)")
            dlUI.createMonthStack(year: year, month: month)
        }
    }
    
    
    private func setDeadlineView() {
        
        let deadlineViewY = deadlineSwitchView.center.y + deadlineSwitchView.frame.height / 2 + view.safeAreaInsets.top
        
        let deadlineView = UIView()
        deadlineView.backgroundColor = .clear
        view.addSubview(deadlineView)
        deadlineView.frame = CGRect(x: 0, y: deadlineViewY, width: view.frame.width, height: 300)
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
        
        //Create weekday stack
        let stack = dlUI.createWeekdayStack()
        stack.frame = CGRect(x: 0, y: buttonSize, width: view.frame.width, height: stackHeight)
        self.deadlineCalendarView.addSubview(stack)
        
        //create monthView
        let components = Calendar.current.dateComponents([.year, .month], from: deadlineCalendarDate)
        guard let year = components.year, let month = components.month else { return }
        
        let dates = dlUI.createMonthStack(year: year, month: month)
        let frames = dlUI.getFrames(days: dates, width: view.frame.width, heigth: deadlineView.frame.height - 75)
        let dayLabels = dlUI.createDayLabels(days: dates)
        
        for i in 0..<dayLabels.count {
            let label = dayLabels[i]
            self.deadlineCalendarView.addSubview(label)
            deadlineDayLabels.append(label)
            label.frame = frames[i]
        }
        
        
    }
    
    
}
