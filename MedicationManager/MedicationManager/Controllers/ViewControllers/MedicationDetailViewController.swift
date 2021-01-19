//
//  MedicationDetailViewController.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import UIKit

class MedicationDetailViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var medicationNameLabel: UITextField!
    @IBOutlet weak var medicationDueDayPicker: UIDatePicker!
    
    // MARK: - Properties
    // create the landing pad for segue
    var medication: Medication?
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let name = medicationNameLabel.text, !name.isEmpty else { return }
        
        if let medication = medication { //if we have medication, then we update info of the medication
            MedicationController.shared.updateMedication(medication: medication, name: name, timeOfDay: medicationDueDayPicker.date)
        } else { //if we don't have medication, we create the medication.
            MedicationController.shared.createMedication(name: name, timeOfDay: medicationDueDayPicker.date)
            
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Fuctions
    func updateViews() {
        guard let medication = medication else { return }
        medicationNameLabel.text = medication.name
        //CoreDate true Date to optional under the hood.
        medicationDueDayPicker.date = medication.timeOfDay ?? Date()
    }
}
