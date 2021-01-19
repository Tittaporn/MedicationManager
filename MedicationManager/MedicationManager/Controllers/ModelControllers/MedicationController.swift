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
    //var medications: [Medication] = []
    var sections: [[Medication]] { [notTakenMeds, takenMeds] }
    var notTakenMeds: [Medication] = []
    var takenMeds: [Medication] = []
    
    
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
    // MARK: - CREATE
    // CREATE
    func createMedication (name: String, timeOfDay: Date){
        // create new medication
        let medication = Medication(name: name, timeOfDay: timeOfDay)
        
        // using this array for section
        notTakenMeds.append(medication)
        
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
    // MARK: - READ
    // READ >> We are going to fetch from Medication
    func fetchMedications (){
        // fetch all medications
        let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
        
        // using filter to fetch them if it takenToday put in takenMeds, if not put in notTakenMeds
        // .filter == for .. in loop
        // $0 represents all each medications
        takenMeds = medications.filter{ $0.wasTakenToday() }
        //This 2 line of code are the same things, short ^ and long
        notTakenMeds = medications.filter({ (med) -> Bool in
            return !med.wasTakenToday() //return the not med that notTakenToday
        })
    }
    /*
     // create computed fetchRequest first and then use it here.
     // running the fetch from the fetchRequest that we just created in the parameter we want to fetch,  and try to fetch if nothing in there .. using ??  [] to return empty array.
     //self.medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
     // 2 line for the logic same as the line up here. ^
     let medications = (try? CoreDataStack.context.fetch(fetchRequest)) ?? []
     self.medications = medications
     */
    
    // MARK: - UPDATE
    // UPDATE
    func updateMedication (medication: Medication, name: String, timeOfDay: Date){
        // Update the medication from the medication that get passed in.
        medication.name = name
        medication.timeOfDay = timeOfDay
        
        // Save in CoreData
        CoreDataStack.saveContext()
    }
    
    //______________________________________________________________________________
    // nt = [vc, vd, ve]
    // t = [iron, zinc]
    
    // create updateMedicationTakenStatus() for the MedicationTakenDelegate protocol
    func updateMedicationTakenStatus(wasTaken: Bool, medication: Medication) {
        
        if wasTaken { //== true {
            
            //Create TakenDate
            TakenDate(date: Date(), medication: medication)
            
            // CoreData have implemented Equable Automatically.
            // find index of specific medication, and remove the that med
            if let index = notTakenMeds.firstIndex(of: medication) {
                notTakenMeds.remove(at: index)
                takenMeds.append(medication)
            }
            
            //Save the data if not save, it gonna sit on RAM not Persistance Store
            //CoreDataStack.saveContext() >>DRY
        } else {
            // Remove it.
            // Make the set mutable // mutableTakenDates >> set form
            // Get the taken date of medication
            let mutableTakenDates = medication.mutableSetValue(forKey: "takenDates") //Using the key from .xcdata ???
            
            // Cast mutableTakenDates as a set of TakenDate object
            // using first(where:..) to iterate through like for..in
            if let takenDate = (mutableTakenDates as? Set<TakenDate>)?.first(where: { (takenDate) -> Bool in
                
                // if it nil return false
                guard let date = takenDate.date else { return false }
                
                // compare the date and today until find the first that is true
                return Calendar.current.isDate(date, inSameDayAs: Date())
            }) { //END OF if let....(condition)..... {}
                
                // if let do something if not nil if found the date is true
                // if we have mutableTakenDates Set then .remove(takenDate) Object out of there.
                mutableTakenDates.remove(takenDate)
                
                //After remove the med, then append to false array
                if let index = takenMeds.firstIndex(of: medication) {
                    takenMeds.remove(at: index)
                    notTakenMeds.append(medication)
                }
                // save on CoreDataStack
                //CoreDataStack.saveContext() >>DRY
            }
            // if let do something if is nil.
        }
        
        CoreDataStack.saveContext() //>>DRY
    }
    // ________________________________________________________________________________
    
    // MARK: - DELETE
    // DELETE
    // TODO : TOMORROW
    func deleteMedication (){
        
    }
}
//______________________________________________________________________________________

/* NOTE
 
 DRY = DO NOT REPEAT YOURSELF
 ______________________________________________________________________________________
 
 Map, Reduce and Filter in Swift
 
 .filter == for .. in loop
 
 In Swift you use map(), reduce() and filter() to loop over collections like arrays and dictionaries, without using a for-loop.
 
 The map, reduce and filter functions come from the realm of functional programming (FP). They’re called higher-order functions, because they take functions as input. You’re applying a function to an array, for example, to transform its data.
 
 Swift’s Map, Reduce and Filter functions can challenging to wrap your head around. Especially if you’ve always coded for in loops to solve iteration problems. In this guide you’ll learn how to use the map(_:), reduce(_:_:) and filter(_:) functions in Swift.
 
 
 https://learnappmaking.com/map-reduce-filter-swift-programming/#introduction-to-map-reduce-and-filter
 
 ______________________________________________________________________________________
 
 Lazy in swift
 When a property is only needed at some point in time, you can prefix it with the lazy keyword so it'll be "excluded" from the initialization process and it's default value will be assigned on-demand. This can be useful for types that are expensive to create, or needs more time to be created. Here is a quick tale of a lazy princess. 👸💤
 
 https://theswiftdev.com/lazy-initialization-in-swift/
 ______________________________________________________________________________________
 Private in swift
 The private keyword is used a lot more and restricts the use of an entity to the enclosing declaration and its extensions. The extensions, however, have to be defined within the same file. In other words, private declarations will not be visible outside the file. You can use this keyword to only expose the minimal code needed to interact with the entity. This will improve readability and makes it easier to use and understand your code for others.
 
 https://www.avanderlee.com/swift/fileprivate-private-differences-explained/
 https://medium.com/swiftworld/swift-world-how-to-use-private-framework-in-swift-b369209e25be
 */



