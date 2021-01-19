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
}

//

/* NOTE
 
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
