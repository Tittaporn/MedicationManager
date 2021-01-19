//
//  CoreDataStack.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import CoreData //import the framwork in order to use it

enum CoreDataStack { //Saving CoreData
    
    // MARK: - Create Container
    // The container == the bank
    static let container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MedicationManager")//Always update the name. This name has to match .xcdatamodeld and the project
        
        //Using completion handler just enter.
        container.loadPersistentStores { (_, error) in
            if let error = error { //contional upwarping using if let. if we have error, it error is not nil, we are going to do something here.
                
                //if an error, just crash the app and print out error
                fatalError("Error loading persistent stores: \(error)")
            }
        }
        
        //if no error, just return container
        return container
    }()
    
    // MARK: - Create Context
    //context == Money to the counter in the bank
    //create context from the container that we just created.
    static var context: NSManagedObjectContext { container.viewContext }
    
    // Go to the vault and save money
    // Save the context when the context has changed.
    static func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}


/* NOTE
 
 NS = Next Step is the company. NS use objectC to create all many codes, then why we use the NS.. , NSString , NS... >> Just for credit for the NS Company.
 
 Container
 inside Container included Persistent Store == long term memory.(hard drive)
 inside Container included context == short term memory.(RAM)
 
 Every time we create meds save in context then using save function (PSC) to save in Persistent Store.
 
 Persistent Store Coordinator
 
 The Persistent Store can used (PSC) to pull the data back to context.
 
 BUT Every time we want to pull the data that we want to load, we have to make a request using "fetch."
 
 _____________________________________________________________________________________________
 
 Persistent Store Coordinator
 
 A persistent store coordinator associates persistent object stores and a managed object model, and presents a facade to managed object contexts such that a group of persistent stores appears as a single aggregate store. A persistent store coordinator is an instance of NSPersistentStoreCoordinator. It has a reference to a managed object model that describes the entities in the store or stores it manages.
 
 https://developer.apple.com/library/archive/documentation/DataManagement/Devpedia-CoreData/persistentStoreCoordinator.html
 
 */
