//
//  TakenDate+Convenience.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/19/21.
//

import CoreData

extension TakenDate {
    // @discardableResult >> allow us to use TakenDate with out capture it >> TakenDate(...)
    // need medication: Medication >> What it belong to??
    @discardableResult convenience init(date: Date, medication: Medication, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context) 
        self.date = date
        self.medication = medication
    }
}
