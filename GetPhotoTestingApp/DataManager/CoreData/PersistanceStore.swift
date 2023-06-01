//
//  PersistentStore.swift
//  GetPhotoTestingApp
//
//  Created by Oleg Stepanov on 30.05.2023.
//

import CoreData

struct PersistentStore {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Image")
        container.loadPersistentStores { desc, error in
            if let error {
                print("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
    }
    
    var context: NSManagedObjectContext { container.viewContext }
    
    func save(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
                print("Data successfuly saved :)")
            } catch (let error) {
                print("Something went wrong, and data couldn't saved: \(error.localizedDescription)")
            }
        }
    }
}
