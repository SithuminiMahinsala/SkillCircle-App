//
//  CoreDataManager.swift
//  SkillCircle
//

import Foundation
import CoreData

/// CoreDataManager provides offline caching and persistent storage

class CoreDataManager {
    static let shared = CoreDataManager()

    private init() {}

    // Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "SkillCircleModel")
        
        // In-memory description fallback if xcdatamodeld isn't pre-compiled
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    // Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("Core Data context saved successfully.")
            } catch {
                let nserror = error as NSError
                print("Failed to save Core Data context: \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //Helper Methods for Session & Notification Caching
    func cacheSessionLocally(id: String, subject: String, tutorName: String, status: String) {
        context.perform {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "CachedSessionEntity", into: self.context)
            entity.setValue(id, forKey: "id")
            entity.setValue(subject, forKey: "subject")
            entity.setValue(tutorName, forKey: "tutorName")
            entity.setValue(status, forKey: "status")
            entity.setValue(Date(), forKey: "cachedAt")
            self.saveContext()
        }
    }

    func fetchCachedSessions() -> [[String: Any]] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CachedSessionEntity")
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject] ?? []
            return results.map { obj in
                [
                    "id": obj.value(forKey: "id") as? String ?? "",
                    "subject": obj.value(forKey: "subject") as? String ?? "",
                    "tutorName": obj.value(forKey: "tutorName") as? String ?? "",
                    "status": obj.value(forKey: "status") as? String ?? ""
                ]
            }
        } catch {
            print("Failed to fetch cached sessions: \(error)")
            return []
        }
    }
}