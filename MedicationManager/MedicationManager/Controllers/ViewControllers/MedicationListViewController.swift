//
//  MedicationListViewController.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import UIKit

class MedicationListViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moodSurveyButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // MedicationController.shared.fetchMedications() >> DO NOT NEED IT HERE, just call it at viewWillAppear
        tableView.delegate = self
        tableView.dataSource = self
        
        // DO NOT FORGET TO FETCH TO SHOW ON THE SCREEN
        MoodSurveyController.shared.fetchMoodSurvey()
        
        // UPDATE TO THE BUTTON TO SHOW ON THE BUTTON
        moodSurveyButton.setTitle(MoodSurveyController.shared.todayMoodSurvey?.emoji ?? "❔", for: .normal)
        
        // Call NotificationCenter for Observer.
        // MoodSurveyViewController is observer.
        // NSNotification.Name("medicationReminderNotification") >> same name as AppDelegate
        // selector is speacial type run an object c upder the hood.
        // #selector(notificationObserved) require object c function
        NotificationCenter.default.addObserver(self, selector: #selector(notificationObserved), name: NSNotification.Name("medicationReminderNotification"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //The orders are very important. Here we need to fetch before reload it.
        MedicationController.shared.fetchMedications()
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func moodSurveyButtonTapped(_ sender: UIButton) {
        // This is coding for segue.
        // We need to set up on storyBoard >> Storyboard ID == identifier of MoodSurveyViewController
        guard let moodSurveyVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "moodSurveyViewController") as? MoodSurveyViewController else { return }
        
        moodSurveyVC.modalPresentationStyle = .fullScreen
        
        // assign the delegate, I wanna be your employee.
        moodSurveyVC.delegate = self
        
        present(moodSurveyVC, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMedicationDetailsVC" {
            guard let indextPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MedicationDetailViewController else { return }
            let medication = MedicationController.shared.sections[indextPath.section][indextPath.row]
            destination.medication = medication
        }
    }
}

// MARK: - Extensions UITableViewDelegate and UITableViewDataSource
extension MedicationListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70.0)
    }
}

extension MedicationListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MedicationController.shared.sections.count //return 2 sections of medication
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // numberOfRow Per Section
        // sections[section] >> [section] == 0 or 1
        return MedicationController.shared.sections[section].count
        //MedicationController.shared.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell ()}
        
        //let medication = MedicationController.shared.medications[indexPath.row]
        
        //Going each section first and go to each row
        let medication = MedicationController.shared.sections[indexPath.section][indexPath.row]
        
        // assign the delegate
        cell.delegate = self
        
        // using external name with for easy to read
        cell.configure(with: medication)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // find the medication from the sections to delete
            let medicationToDelete = MedicationController.shared.sections[indexPath.section][indexPath.row]
            
            // using the deleteMedication(..) to delete from S.O.T. and Persistance store
            MedicationController.shared.deleteMedication(medication: medicationToDelete)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // getting title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "NOT Taken Medicine"
        } else {
            return "Taken Medicine"
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemTeal
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.blue
        header.textLabel?.font = UIFont(name: "Apple Color Emoji", size: 20)
    }
}

// MARK: - Extension MedicationTakenDelegate
extension MedicationListViewController: MedicationTakenDelegate {
    
    // confrom the protocol
    func medicationWasTakenTapped(wasTaken: Bool, medication: Medication) {
        // write the code that the boss said do this job, and the employee does the job in detail
        print("Delegate doing it's thing...")
        
        // tell my model controller to mark a medication as taken or untaken?
        // call updateMedication
        MedicationController.shared.updateMedicationTakenStatus(wasTaken: wasTaken, medication: medication)
        
        // don't forget to reload data
        tableView.reloadData()
    }
    
    // using this funtion to run when notification working
    @objc func notificationObserved() {
        
        let bgColor = tableView.backgroundColor
        tableView.backgroundColor = .red
        // using DispatchQueue.???
        // 2 sec later it is going to  {...do something in the block....}
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.tableView.backgroundColor = bgColor
        }
    }
}

extension MedicationListViewController: MoodSurveyViewControllerDelegate {
    func emojiSelected(emoji: String) {
        
        // Got the data
        print("emoji in MedicationListViewController : \(emoji)")
        
        // Using the func in ModelController
        MoodSurveyController.shared.didTapEmoji(emoji: emoji)
        
        // Update the view. Display Emoji on the button.
        moodSurveyButton.setTitle(emoji, for: .normal)
    }
}

/* Notification Observer
 The Observer: The recipient which is waiting for the notification to be triggered, to execute whatever code you want it to.
 The Notification: The actual notification that it is going to be fired whenever we intend the Observer to perform a certain action. And, we can have as many notifications as we want, all over the app.
 
 https://medium.com/better-programming/ios-lets-implement-that-notification-observer-communication-pattern-fc513f61b33e
 */
