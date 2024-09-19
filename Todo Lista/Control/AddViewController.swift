//
//  AddViewController.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

class AddViewController: UIViewController {
    
    let dlUI = DeadlineUI()
    let CoreData = CoreDataStack()
    
    var deadlineCalendarDate = Date()
    var deadlineDayLabels = [UILabel]()
    var newDeadlineDayLabels = [UILabel]()
    var lowView = UIView()
    var impSwitch = UISwitch()
    var deleteButton = UIButton()
    
    var hasSetUI = false
    var taskID: Int?
    var selectedDeadlineDate: Int?
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descTextField: UITextField!
    @IBOutlet weak var deadlineSwitchView: UIView!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var monthTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetUI {
            setDeadlineCalendar(for: deadlineCalendarDate, location: 0)
            finishUI()
            hasSetUI = true
        }
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        
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
        var translationY: CGFloat {
            if sender.isOn {
                return calendarView.frame.height + 70
            } else {
                for label in deadlineDayLabels {
                    label.backgroundColor = .clear
                    label.textColor = .black
                }
                selectedDeadlineDate = nil
                return -calendarView.frame.height - 70
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.lowView.center.y += translationY
        })
    }
    
    @objc func impSwitchToggled(_ sender: UISwitch) {
        
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        for label in deadlineDayLabels {
            label.backgroundColor = .clear
            label.textColor = .black
        }
        if let tappedLabel = sender.view as? UILabel {
            tappedLabel.backgroundColor = UIColor(named: C.Colors.brandColor)
            tappedLabel.textColor = .white
            selectedDeadlineDate = tappedLabel.tag
        }
    }
    
    @objc func deleteButtonTapped() {
        print("Poista tehtävä button tapped")
    }

    func createTask() {
        guard let name = nameTextField.text else {
            return
        }
        let desc = descTextField.text
        let isImportant = impSwitch.isOn
    }
    
    
}


extension AddViewController {
    
//MARK: - Set Deadlinecalendar
    
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
            
            label.tag = Int(d.dateString) ?? 100
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
            label.addGestureRecognizer(tapGesture)
            
        }
        
    }
    
//MARK: Move calendar with animation
    
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
    
    private func finishUI() {
        
        let y = view.safeAreaInsets.top + calendarView.center.y - calendarView.frame.height / 2 - 60
        
        let lowerView = UIView()
        lowerView.backgroundColor = .white
        lowerView.frame = CGRect(x: 0, y: y, width: view.frame.width, height: 400)
        view.addSubview(lowerView)
        lowView = lowerView
        
        let label = UILabel()
        label.text = "Merkitse tärkeäksi"
        label.font = UIFont(name: "Helvetica", size: 22)

        
        label.textColor = UIColor(named: C.Colors.brandColor)
        lowerView.addSubview(label)
        label.frame = CGRect(x: 20, y: 0, width: view.frame.width - 50, height: 50)
        
        let iSwitch = UISwitch()
        iSwitch.onTintColor = UIColor(named: C.Colors.brandColor)
        lowerView.addSubview(iSwitch)
        iSwitch.frame = CGRect(x: view.frame.width - 70, y: 10, width: 70, height: 40)
        iSwitch.addTarget(self, action: #selector(impSwitchToggled(_:)), for: .valueChanged)
        impSwitch = iSwitch
        
        
        let button = UIButton(type: .system)
        button.setTitle("Poista tehtävä", for: .normal)
        button.setTitleColor(.red, for: .normal)  // Set red text
        button.frame = CGRect(x: 10, y: 45, width: 150, height: 40)
        lowerView.addSubview(button)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        deleteButton = button
        
        
    }
    
}
