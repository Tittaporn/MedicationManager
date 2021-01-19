//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import UIKit

class MedicationTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationTimeLabel: UILabel!
    @IBOutlet weak var hasTakenButton: UIButton!
    
    // MARK: - Actions
    @IBAction func hasTakenButtonTapped(_ sender: Any) {
        print("Has taken button tapped.")
    }
    
    // MARK: - Helper Fuctions
    func updateViews(medication: Medication) {
        
        medicationNameLabel.text = medication.name
        
        //Create Helpers folder and create the DateFormatter then use in here.
        medicationTimeLabel.text = DateFormatter.medicationTime.string(from: medication.timeOfDay ?? Date())
    }
}
