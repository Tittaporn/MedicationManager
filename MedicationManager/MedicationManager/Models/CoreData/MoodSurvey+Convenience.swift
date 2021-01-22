//
//  MoodSurvey+Convenience.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/21/21.
//

import CoreData

extension MoodSurvey {
    @discardableResult convenience init(emoji: String, date: Date, context: NSManagedObjectContext = CoreDataStack.context) {
        self.init(context: context)
        self.emoji = emoji
        self.date = date
    }
}
