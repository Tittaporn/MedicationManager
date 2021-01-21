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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
