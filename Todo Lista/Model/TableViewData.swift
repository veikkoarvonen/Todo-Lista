//
//  TableViewData.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 21.9.2024.
//

import Foundation

struct TableViewData {
    
    func getTaskArray() -> [Task] {
        guard let tasks = CoreDataStack.shared.fetchTasks() else {
            print("Error fetching tasks for task array")
            return []
        }
        
        return tasks
    }
    
}
