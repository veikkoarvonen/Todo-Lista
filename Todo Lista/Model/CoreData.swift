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
    
    init() {}
    
    // Persistent container setup
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo_Lista") // Use the name of your Core Data model file
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
    
    func createTask(name: String, desc: String?, deadline: Date?, id: Int, isCompleted: Bool, isImportant: Bool) {
        let context = context
        
        // Create a new task
        let task = Task(context: context)
        task.name = name
        task.desc = desc
        task.deadline = deadline
        task.id = Int32(id)
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
    
    func updateTask(id: Int32, name: String, desc: String?, deadline: Date?, isImportant: Bool) {
        let context = context
        
        guard let task = fetchTaskByID(taskID: id) else { return }
        
        task.name = name
        task.desc = desc
        task.deadline = deadline
        task.isImportant = isImportant
        
        saveContext()
    }
    
    func markTaskCompleted(id: Int32, completed: Bool) {
        let context = context
        
        guard let task = fetchTaskByID(taskID: id) else { return }
        
        task.isCompleted = completed
        
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

    func deleteTask(taskID: Int32) {
        if let taskToDelete = fetchTaskByID(taskID: taskID) {
            let context = context
            context.delete(taskToDelete)
            saveContext()
        }
    }



}
