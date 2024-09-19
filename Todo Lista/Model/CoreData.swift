//
//  CoreData.swift
//  Todo Lista
//
//  Created by Veikko Arvonen on 19.9.2024.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()
    
    private init() {}
    
    // Persistent container setup
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskDataModel") // Use the name of your Core Data model file
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Save the context
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createTask(name: String, desc: String, deadline: Date, id: Int32, isCompleted: Bool, isImportant: Bool) {
        let context = context
        
        // Create a new task
        let task = Task(context: context)
        task.name = name
        task.desc = desc
        task.deadline = deadline
        task.id = id
        task.isCompleted = isCompleted
        task.isImportant = isImportant
        
        // Save the task
        saveContext()
    }
    
    func fetchTasks() -> [Task]? {
        let context = CoreDataStack.shared.context
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Failed to fetch tasks: \(error)")
            return nil
        }
    }
    
    func updateTask(task: Task, name: String, desc: String, deadline: Date, isCompleted: Bool, isImportant: Bool) {
        let context = context
        
        task.name = name
        task.desc = desc
        task.deadline = deadline
        task.isCompleted = isCompleted
        task.isImportant = isImportant
        
        saveContext()
    }
    
    func fetchTaskByID(taskID: Int32) -> Task? {
        let context = context
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        // Set the predicate to filter by task ID
        fetchRequest.predicate = NSPredicate(format: "id == %d", taskID)
        
        do {
            let tasks = try context.fetch(fetchRequest)
            
            // If a task with the given ID exists, return it
            return tasks.first
        } catch {
            print("Failed to fetch task with ID \(taskID): \(error)")
            return nil
        }
    }




}
