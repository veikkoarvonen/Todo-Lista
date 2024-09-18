//
//  ViewController.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 18.9.2024.
//

import UIKit

class MainViewController: UIViewController {

//MARK: - Variables
    
    var topLabels = [UILabel]()
    
//MARK: - IBoutlets & actions
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTopLabels()
    }
    
    
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
        }
    }
    
}

