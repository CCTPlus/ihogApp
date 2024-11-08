//
//  Persistence.swift
//  iHog
//
//  Created by Jay Wilson on 9/16/20.
//

import CoreData

struct PersistenceController {
    // app uses
    static let shared = PersistenceController()

    //preview uses
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = ShowEntity(context: viewContext)
            newItem.dateCreated = Date()
            newItem.dateLastModified = Date()
            newItem.name = "TEST SHOW 101"
            newItem.id = UUID()
            newItem.note = "Show notes go here"
            
            let newObject = ShowObjectEntity(context: viewContext)
            newObject.id = UUID()
            newObject.number = 1.2
            newObject.name = "All Stage Wash"
            newObject.objColor = "red"
            newObject.objType = "group"
            newObject.isOutlined = true
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            Analytics.shared.logError(with: error, for: .coreData)
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "iHog")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                Analytics.shared.logError(with: error, for: .coreData)
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                Typical reasons for an error here include:
                * The parent directory does not exist, cannot be created, or disallows writing.
                * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                * The device is out of space.
                * The store could not be migrated to the current model version.
                Check the error message to determine what the actual problem was.
                */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
