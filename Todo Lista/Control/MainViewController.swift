//
//  ViewController.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

class MainViewController: UIViewController, ReloadDelegate {

//MARK: - Variables
    
    var topLabels = [UILabel]()
    var tableViewData = 1
    var tableViewDataArray = [Task]()
    let coreData = CoreDataStack()
    let tableData = TableViewData()
    var taskID: Int?
    
//MARK: - IBoutlets & actions
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: C.Segues.mainToAdd, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopLabels()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        tableView.register(UINib(nibName: C.TableView.cellName, bundle: nil), forCellReuseIdentifier: C.TableView.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        DispatchQueue.main.async {
            self.initializeTableViewCells()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == C.Segues.mainToAdd {
            let destinationVC = segue.destination as! AddViewController
            destinationVC.taskID = taskID
            taskID = nil
        }
    }

  
//MARK: - Handle panGesture
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.view)
        let centerX = view.frame.width / 2
        let labelWidth = view.frame.width * (2 / 5)
        let centerLimits = [centerX - labelWidth / 2, centerX + labelWidth / 2]
        let centerXValues = [centerX + labelWidth, centerX, centerX - labelWidth]
        
        switch gesture.state {
        case .changed:
            
            //Move labes horizontally with translation
            for label in topLabels {
                label.center.x += translation.x
            }
            gesture.setTranslation(CGPoint.zero, in: self.view)
        case .ended:
            var oldDataIndex = tableViewData
            let velocity = gesture.velocity(in: self.view)
            let c = topLabels[1].center.x
            
            //Determine future tableViewData based on gesture
            if velocity.x < -1000 {
                tableViewData = min(tableViewData + 1, 2)
            } else if velocity.x > 1000 {
                tableViewData = max(tableViewData - 1, 0)
            } else {
                if c < centerLimits[0] {
                    tableViewData = 2
                } else if c < centerLimits[1] {
                    tableViewData = 1
                } else {
                    tableViewData = 0
                }
            }
            
           //Determine final point for center label based on tableView's data
            let finalCenterXforMiddleLabel = centerXValues[tableViewData]
            
            //Calculate final translation and move labels
            let finalTranslationX = finalCenterXforMiddleLabel - c
            UIView.animate(withDuration: 0.3, animations: {
                for label in self.topLabels {
                    label.center.x += finalTranslationX
                }
            }) { [self] _ in
                if oldDataIndex < tableViewData {
                    refreshTableView(forDataInt: tableViewData, movedRight: true)
                } else if oldDataIndex > tableViewData {
                    refreshTableView(forDataInt: tableViewData, movedRight: false)
                }
            }

        default:
            break
        }
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
//MARK: - TableView animations and data updates
    
    func initializeTableViewCells() {
        let dataArray = tableData.getTaskArray()
        tableViewDataArray = dataArray
        
        var iPaths: [IndexPath] = []
        for i in 0..<dataArray.count {
            iPaths.append(IndexPath(row: i, section: 0))
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: iPaths, with: .left)
        tableView.endUpdates()
        
    }
    
    func refreshTableView(forDataInt dataInt: Int, movedRight: Bool) {
        var iPathsToRemove: [IndexPath] = []
        for i in 0..<tableViewDataArray.count {
            iPathsToRemove.append(IndexPath(row: i, section: 0))
        }
        
        tableViewDataArray = []
        
        tableView.beginUpdates()
        if movedRight {
            tableView.deleteRows(at: iPathsToRemove, with: .left)
        } else {
            tableView.deleteRows(at: iPathsToRemove, with: .right)
        }
        tableView.endUpdates()
        
        var newDataArray: [Task] {
            switch tableViewData {
            case 0: return tableData.getImportantArray()
            case 1: return tableData.getTaskArray()
            case 2: return tableData.getDeadlines()
            default: return tableData.getTaskArray()
            }
        }
        
        var iPathsToAdd: [IndexPath] = []
        for i in 0..<newDataArray.count {
            iPathsToAdd.append(IndexPath(row: i, section: 0))
        }
        
        tableViewDataArray = newDataArray
        
        tableView.beginUpdates()
        if movedRight {
            tableView.insertRows(at: iPathsToAdd, with: .right)
        } else {
            tableView.insertRows(at: iPathsToAdd, with: .left)
        }
        tableView.endUpdates()
        
        print(tableViewDataArray.count)
        
    }
    
    
    
//MARK: - Set UI
    
    private func setTopLabels() {
        
        let labelWidth = view.frame.width * (2 / 5)
        let c = topView.center.x
        let centerXValues = [c - labelWidth, c, c + labelWidth]
        let labelTexts = ["Tärkeät","Tehtävät","Deadlinet"]
        
        for i in 0...2 {
            let label = UILabel()
            label.text = labelTexts[i]
            label.font = UIFont(name: "Optima", size: 15)
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.textColor = .white
            view.addSubview(label)
            label.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 30)
            label.center.y = topView.center.y
            label.center.x = centerXValues[i]
            topLabels.append(label)
        }
    }
    
}

//MARK: - Table view methods

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableViewDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.TableView.cellID, for: indexPath) as! TableViewCell
        
        let item = tableViewDataArray[indexPath.row]
        var nameString = item.name!
        if item.isImportant && tableViewData != 0 {
            nameString = "\(nameString)❗️"
        }
        cell.nameLabel.text = nameString
        
        if let desc = item.desc {
            cell.descLabel.text = desc
        }
        
        if let dl = item.deadline {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yy"
            cell.deadlineLabel.text = "Deadline: \(formatter.string(from: dl))"
            
            if tableViewData == 2 {
                let comps = Calendar.current.dateComponents([.day], from: Date(), to: dl)
                if let difference = comps.day {
                    cell.timeLabel.text = "Aikaa \(difference) pv"
                }
            } else {
                cell.timeLabel.text = ""
            }
        } else {
            cell.deadlineLabel.text = "Ei deadlinea"
            cell.timeLabel.text = ""
        }
        
        cell.taskID = item.id
        cell.delegate = self
        
        if item.isCompleted {
            cell.backView.alpha = 0.5
            cell.completedButton.tintColor = UIColor(named: C.Colors.brandColor)
        } else {
            cell.backView.alpha = 1
            cell.completedButton.tintColor = .systemGray3
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = tableViewDataArray[indexPath.row]
        if item.desc != nil && item.desc != "" {
            return 130
        } else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = tableViewDataArray[indexPath.row]
        taskID = Int(item.id)
        performSegue(withIdentifier: C.Segues.mainToAdd, sender: self)
    }
    
    
}
