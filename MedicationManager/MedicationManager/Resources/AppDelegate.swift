//
//  AppDelegate.swift
//  MedicationManager
//
//  Created by Aaron Martinez on 12/20/20.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        print("LANCHED") //The app start with this before doing anything else.
        
        //Asking for authorization to send notification to user.
        // User allow or Not allow : Bool >> authorized, error: Error?
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (authorized, error) in
            
            if let error = error {
                print("There was an error requesting authorization to use notifications. Error: \(error.localizedDescription)")
            }
            if authorized {
                
                //Set delegate to UNUserNotificationCenterDelegate
                UNUserNotificationCenter.current().delegate = self
                
                print("✅ The user authorized notifications.")
            } else {
                print("❌ The user did not authorized notifications.")
            }
        }
        
        return true
    }
    //______________________________________________________________________________________
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

//______________________________________________________________________________________

// MARK: - Extension UNUserNotificationCenterDelegate
// When you are about to present notification. if in the app, won't display.
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // WillPresent
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification will present...")
        
        // When I m done here. >> I want to completionHandler
        // Notification post in your system. Post the name of notification.
        // Notification.Name(rawValue:  ) >> object c === identifier
        NotificationCenter.default.post(name: Notification.Name(rawValue: "medicationReminderNotification"), object: nil)
        
        // When I m done up here. >> I want to completionHandle add sound the banner to my app even I am not on the app.
        completionHandler([.sound, .banner])
    }
    
}

/* NOTE
 
 Notification Observer
 
 How Notification Center Works
 We’ll start with how NotificationCenter exactly works. It has three components:
 
 - A “listener” that listens for notifications, called an observer
 - A “sender” that sends notifications when something happens
 - The notification center itself, that keeps track of observers and notifications
 - The mechanism is simple. Let’s look at an analogy:
 
 - You’re working in a mail processing facility that delivers mail to 5 coloured streets
 - You, the postman, need to deliver purple letters to purple street whenever they arrive at the mail processing facility
 - When your shift starts, you tell the central command of the mail facility – let’s call him Bob – that you want to know when purple mail arrives
 - Some time passes, and Alice – who lives on yellow street – decides to send a letter to purple street
 - So, she sends her letter to the mail processing facility, where it is picked up by Bob – the central command – who informs you that a purple letter has arrived
 - You get the purple letter from Bob, and safely deliver it on purple street
 
 https://learnappmaking.com/notification-center-how-to-swift/
 
 https://medium.com/better-programming/ios-lets-implement-that-notification-observer-communication-pattern-fc513f61b33e
 */

