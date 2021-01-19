//
//  Medication+Convenience.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import CoreData

//The initialize on the Medication already exist under the hood.
extension Medication {
    
    // we modify the default init by using the  convenience init
    // Why @discardableResult ??
    // Using this init to location where the CoreDataStack.context
    @discardableResult convenience init(name: String, timeOfDay: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context) //self.init is calling from the default init
        self.name = name
        self.timeOfDay = timeOfDay
    }
    
    //  ___________________________________________________________________________
    
    // Write a Fuction return true of false that can use anywhere.
    func wasTakenToday() -> Bool {
        
        // casting as Set of TakenDate Object
        // .first(where: <#T##(TakenDate) throws -> Bool#>) >> is a function that find the first element. Returns the first element of the sequence that satisfies the given predicate. Return ture or false
        
        // guard let to check if we have the date
        //  let takenDate = takenDates
        guard let _ = (takenDates as? Set<TakenDate>)?.first(where: { (takenDate) -> Bool in
            
            guard let date = takenDate.date else { return false }
            // check if theTakenDate == today or Not??
            // .isDate(<#T##date1: Date##Date#>, inSameDayAs: <#T##Date#>) >> is date is the same day as today.
            // inSameDayAs Only compare the day, NOT TIME, HOURS, SEC...
            return Calendar.current.isDate(date, inSameDayAs: Date()) //return ture if the same day and false if not.... And keep finding the date in the next element.
            
        }) else { return false }
        
        return true
    }
    
    //  ___________________________________________________________________________
}

//

/* NOTE
 
 let numbers = [1,2,3]
 for number in numbers {
 ....
 }
 
 ________________________________________________________________
 
 Array VS Set
 
 // Array >> Can have dupicate data.
 
 // Set >> CoreData using unique elements. CAN NOT dupicate data.
 >> sets are immutable??
 >> sets are An unordered collection of unique elements.
 // NSSet
 An object representing a static, unordered, uniquing collection, for use instead of a Set constant in cases that require reference semantics.
 
 Go for an Array if:
 - Order is important
 - Duplicate elements should be possible
 - Performance is not important
 
 Go for a Set if:
 - Order is not important
 - Unique elements is a requirement
 - Performance is important
 
 https://www.avanderlee.com/swift/array-vs-set-differences-explained/#:~:text=%20Array%20vs%20Set%3A%20Fundamentals%20in%20Swift%20explained,differences%20between%20an%20Array%20and%20a...%20More%20
 ________________________________________________________________
 
 @discardableResult in Swift
 
 Normal Way to create the newMed
 let newMed = Medication(name: <#T##String#>, timeOfDay: <#T##Date#>)
 
 BUT USING >>> @discardableResult
 Medication(name: <#T##String#>, timeOfDay: <#T##Date#>)
 
 The discardable result attribute might be less known but is really useful to hide warnings pointing to unused return values. Simply add the @discardableResult attribute to your method and the warnings disappears. Decide carefully for each method whether it’s important to handle the return value or not. In some cases, it might be better to force the user of your method to handle the result.
 
 https://www.avanderlee.com/swift/discardableresult/
 _____________________________________________________________________________________
 
 Why?? CoreData ??
 - fast
 - part of cloud service
 - a lot of company use coreData
 - not a lot of people use coreData
 
 Core Data is just a framework like UIKit. It is used to manage data/models. There are a couple of notable built-in features such as 1. change tracking of data, 2. undo and redo to data 3. Filtering 4. Save on to the disk. 5. Partial loading unlike UserDefaults
 It is true that there are other frameworks built by non-Apple engineers such as Realm which acts like Core Data and feel free to use that instead.
 
 https://blog.bobthedeveloper.io/beginners-guide-to-core-data-in-swift-3-85292ef4edd
 */
