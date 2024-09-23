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
    
    func getImportantArray() -> [Task] {
        guard let tasks = CoreDataStack.shared.fetchTasks() else {
            print("Error fetching tasks for important array")
            return []
        }
        
        var importantTasks: [Task] {
            var impTasks: [Task] = []
            for task in tasks {
                if task.isImportant {
                    impTasks.append(task)
                }
            }
            return impTasks
        }
        
        return importantTasks
    }
    
    func getDeadlines() -> [Task] {
        // Fetch tasks from Core Data
        guard let tasks = CoreDataStack.shared.fetchTasks() else {
            print("Error fetching tasks for deadlines array")
            return []
        }

        // Filter tasks that have a non-nil deadline and are not completed
        var deadlines: [Task] = tasks.filter { $0.deadline != nil && !$0.isCompleted }

        // Sort the tasks by their deadline property from earliest to latest
        deadlines.sort { (task1, task2) -> Bool in
            guard let deadline1 = task1.deadline, let deadline2 = task2.deadline else {
                return false
            }
            return deadline1 < deadline2
        }

        return deadlines
    }


    
}
