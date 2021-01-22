//
//  MoodSurveyViewController.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/20/21.
//

import UIKit

// MARK: - Protocol
protocol MoodSurveyViewControllerDelegate: AnyObject {
    func emojiSelected(emoji: String)
}

class MoodSurveyViewController: UIViewController {
    
    
    // MARK: - Protocol
    weak var delegate: MoodSurveyViewControllerDelegate?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Call NotificationCenter for Observer.
        // MoodSurveyViewController is observer.
        // NSNotification.Name("medicationReminderNotification") >> same name as AppDelegate
        // selector is speacial type run an object c upder the hood.
        // #selector(notificationObserved) require object c function
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserved), name: NSNotification.Name("medicationReminderNotification"), object: nil)
    }
    
    // MARK: - Actions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // sender >> every time button was tapped. Each button has it own sender.
    @IBAction func emojiButtonTapped(_ sender: UIButton) {
        // if sender: Any >> HAVE NO Title.. >>> sender.titleLabel?.text XXX
        
        // tell my listViewController which emoji was selected.  || (button) was tapped.
        guard let emoji = sender.titleLabel?.text else { return }
        print(emoji)
        delegate?.emojiSelected(emoji: emoji)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Notification Function
    // using this funtion to run when notification working
    @objc func notificationObserved() {
        let bgColor = view.backgroundColor
        view.backgroundColor = .red
        
        // using DispatchQueue.???
        // 2 sec later it is going to  {...do something in the block....}
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.view.backgroundColor = bgColor
            
        }
    }
}
