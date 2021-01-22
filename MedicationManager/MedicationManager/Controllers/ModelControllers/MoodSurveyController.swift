//
//  MoodSurveyController.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/21/21.
//

import CoreData

class MoodSurveyController {
    
    // MARK: - Properties
    // Shared Instance
    static let shared = MoodSurveyController()
    
    // S.O.T.
    var todayMoodSurvey: MoodSurvey?
    
    // MARK: - NSFetchRequest
    // return == : NSFetchRequest<MoodSurvey>
    private lazy var fetchRequest: NSFetchRequest<MoodSurvey> = {
        let request = NSFetchRequest<MoodSurvey>(entityName: "MoodSurvey")
        
        // request.predicate = NSPredicate(value: true) // return all fetch
        // predicate == searching condition, or filtering condition
        // predicate is object c code.
        
        // we are looking for today Mood. SO...
        // 1) set predicate greater than today
        // 2) set predicate less than today
        
        // Looking for today
        let startOfToday = Calendar.current.startOfDay(for: Date())
        // object c can not handle startOfToday because it is in swift. SO  casting it to object c >> as NSDate
        // "date ===== todayDAte > %@" ===== replace args: CVarg...
        let afterStartOfToday = NSPredicate(format: "date > %@", startOfToday as NSDate)
        
        
        // using .date(byAdding:..(full day)) to find the endOfToday from startOfToday
        let endOfToday = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday) ?? Date() //==(byAdding: .hour, value: 24, to: startOfToday) == one full day // >> using nil coalescing to cast it before next line.
        let beforeEndOfToday = NSPredicate(format: "date < %@", endOfToday as NSDate)
        
        
        // Using NSCompoundPredicate to look for both condition
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [afterStartOfToday, beforeEndOfToday])
        
        return request
    }()
    
    //______________________________________________________________________________________
    
    // MARK: - CRUD Methods
    // CREATE
    func createMoodSurvey(emoji: String) {
        let moodSurvey = MoodSurvey(emoji: emoji, date: Date())
        todayMoodSurvey = moodSurvey
        CoreDataStack.saveContext() // == CoreDataStack.context.save()
        print("MoodSurey was created.")
    }
    
    // READ
    func fetchMoodSurvey() {
        // it come back in array form, then we need the first in array
        let todayMoodSurvey = try? CoreDataStack.context.fetch(fetchRequest).first
        
        // assign to the todayMoodSurvey
        self.todayMoodSurvey = todayMoodSurvey
        CoreDataStack.saveContext()
        print("MoodSurey was fetched.")
    }
    
    // UPDATE
    func updateMoodSurvey(emoji: String) {
        if let survey = todayMoodSurvey {
            survey.emoji = emoji
            CoreDataStack.saveContext()
            print("MoodSurey was updated.")
        }
        /* >> === if let same as guard let here >>>
         guard let survey = todayMoodSurvey else { return }
         survey.emoji = emoji
         CoreDataStack.saveContext()
         */
    }
    
    // Choosing emoji in ViewController, but better put it here in ModelController.
    func didTapEmoji(emoji: String) {
        print("\(#function) was run.")
        if todayMoodSurvey != nil { // if moodSurvey not nil do this >>
            updateMoodSurvey(emoji: emoji)
        } else { //
            createMoodSurvey(emoji: emoji)
        }
    }
    
    // DELETE
    // NO DELETE NEEDED AT THE TIME.
}
