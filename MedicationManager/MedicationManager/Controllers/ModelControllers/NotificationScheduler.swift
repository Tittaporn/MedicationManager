//
//  NotificationScheduler.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/20/21.
//

import UserNotifications //Framework for using Notification

class NotificationScheduler {
    
    // MARK: - scheduleNotifications
    func scheduleNotifications(medication: Medication) {
        
        // guard this timeOfDay for the dateComponents
        guard let timeOfDay = medication.timeOfDay,
              let id = medication.id else { return }
        
        // this content for notification
        let content = UNMutableNotificationContent()
        content.title = "REMINDER!"
        content.body = "It is time to take your \(medication.name ?? "medication")." //using  nil coalescing when it nil.
        content.sound = .default //This Can change to any sound.
        
        // getting date component for trigger, only need [.hour,.minute] from medication.timeOfDay which we have to use guard on the top of this func
        let dateComponents = Calendar.current.dateComponents([.hour,.minute], from: timeOfDay)
        
        // using calendar
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // identifier for looking for it when we need to cancel or do something with it.
        let request = UNNotificationRequest(identifier: "\(id)", content: content, trigger: trigger)
        
        // Start WITH THIS LINE. AND WORK BACKWARD. TO FIND <#T##UNNotificationContent#> AND <#T##UNNotificationTrigger?#>
        //we need to add the notification that why need request ^
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                print("Unable to add notification request: \(error.localizedDescription)")
            }
        }
    }
//______________________________________________________________________________________
    
    // When you delete medication, you need to cancel notification.
    func cancelNotification(medication: Medication) {
        
        guard let id = medication.id else { return }
        
        // To remove the old notificatioin
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

//______________________________________________________________________________________

/* NOTE
 UUID == Universally Unique Identifier
 The term UUID stands for Universally Unique Identifier. In Swift, we can generate UUIDs with the UUID struct.
 The UUID() initializer generates 128 random bits. Because the UUID struct conforms to the CustomStringConvertible, we can print it as a string.
 https://learnappmaking.com/random-unique-identifier-uuid-swift-how-to/#:~:text=Random%20unique%20identifiers%20%28UUIDs%29%20are%20super%20useful%20in,devices%2C%20all%20users%2C%20all%20objects%20in%20the%20database.


//______________________________________________________________________________________
 User Notifications
 - User-facing notifications communicate important information to users of your app, regardless of whether your app is running on the user's device. For example, a sports app can let the user know when their favorite team scores. Notifications can also tell your app to download information and update its interface. Notifications can display an alert, play a sound, or badge the app's icon.
 - With iOS 10, tvOS 10, and watchOS 3, Apple is introducing a new framework called the UserNotifications framework. This brand new set of APIs provides a unified, object-oriented way of working with both local and remote notifications on these platforms. This is particularly useful as, compared to the existing APIs, local and remote notifications are now handled very similarly, and accessing notification content is no longer done just through dictionaries.
 - The new UserNotifications framework provides fully functional and easy-to-use object-oriented APIs for working with local and remote notifications on iOS, watchOS, and tvOS. It makes it very easy to schedule local notifications for a variety of scenarios as well as greatly simplifying the whole flow of processing incoming notifications and custom actions.

 1. Registering for Notifications
 2. Scheduling Notifications
 3. Receiving Notifications
 4. Managing Notifications
 5. Custom Action Notifications

 https://developer.apple.com/documentation/usernotifications/
 
 https://code.tutsplus.com/tutorials/an-introduction-to-the-usernotifications-framework--cms-27250

 */
