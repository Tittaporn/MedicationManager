//
//  MedicationController.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

//import Foundation
import CoreData //DO NOT Forget to import to use fetch request

class MedicationController {
    
    // MARK: - Properties
    // Shared Instance
    static let shared = MedicationController()
    
    // S.O.T
    var medications: [Medication] = []
    
    // Fetch Request
    // private >> only for using to access only this class
    // lazy >> to prevent from the background runing for no reason, this will get called when it need it. Only run when it needed.
    private lazy var fetchRequest: NSFetchRequest<Medication> = {
        
        //create the request to look for Medication object.
        let request = NSFetchRequest<Medication>(entityName: "Medication")
        
        //Using predicate to search for something that you need from the container
        request.predicate = NSPredicate(value: true)
        
        return request
    }()
    
    // MARK: - CRUD Methods
    // CREATE
    func createMedication (name: String, timeOfDay: Date){
        // create new medication
        Medication(name: name, timeOfDay: timeOfDay)
        
        // DO NOT NEED append to medications IN this case  >> medications.append(newMed)
        
        //Using CoreDataStack.saveContext() to save newMed and then we will fetch it from the  fetchMedication ()
        CoreDataStack.saveContext()
    }
    
    /* This line below should work same as the line up here ^.
     func createMedication(name: String, timeOfDay: Date) {
     let medication = Medication(name: name, timeOfDay: timeOfDay)
     medications.append(medication)
     CoreDataStack.saveContext()
     }
     
     */
    
    // READ >> We are going to fetch from Medication
    func fetchMedications (){
        // create computed fetchRequest first and then use it here.
        // running the fetch from the fetchRequest that we just created in the parameter we want to fetch,  and try to fetch if nothing in there .. using ??  [] to return empty array.
        self.medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        /* 2 line for the logic same as the line up here. ^
         let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
         self.medications = medications
         */
    }
    
    // UPDATE
    func updateMedication (medication: Medication, name: String, timeOfDay: Date){
        // Update the medication from the medication that get passed in.
        medication.name = name
        medication.timeOfDay = timeOfDay
        
        // Save in CoreData
        CoreDataStack.saveContext()
    }
    
    // DELETE
    // TODO : TOMORROW
    func deleteMedication (){
        
    }
}

/* NOTE
 Lazy in swift
 When a property is only needed at some point in time, you can prefix it with the lazy keyword so it'll be "excluded" from the initialization process and it's default value will be assigned on-demand. This can be useful for types that are expensive to create, or needs more time to be created. Here is a quick tale of a lazy princess. 👸💤
 
 https://theswiftdev.com/lazy-initialization-in-swift/
 ______________________________________________________________________________________
 Private in swift
 The private keyword is used a lot more and restricts the use of an entity to the enclosing declaration and its extensions. The extensions, however, have to be defined within the same file. In other words, private declarations will not be visible outside the file. You can use this keyword to only expose the minimal code needed to interact with the entity. This will improve readability and makes it easier to use and understand your code for others.
 
 https://www.avanderlee.com/swift/fileprivate-private-differences-explained/
 https://medium.com/swiftworld/swift-world-how-to-use-private-framework-in-swift-b369209e25be
 */



