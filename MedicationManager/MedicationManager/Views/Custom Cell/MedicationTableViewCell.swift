//
//  MedicationTableViewCell.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import UIKit

// MARK: - Protocol
// Create the protocol to communicate that the buttonHastakenWasTapped
protocol MedicationTakenDelegate: AnyObject {
    func medicationWasTakenTapped(wasTaken: Bool, medication: Medication)
}

class MedicationTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var medication: Medication?
    var wasTakenToday: Bool = false
    
    // Create Delegate the employee for MedicationTakenDelegate
    weak var delegate: MedicationTakenDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var medicationNameLabel: UILabel!
    @IBOutlet weak var medicationTimeLabel: UILabel!
    @IBOutlet weak var hasTakenButton: UIButton!
    
    // MARK: - Actions
    @IBAction func hasTakenButtonTapped(_ sender: Any) {
        print("Has taken button tapped.")
        // need to create property hasMedicationTaken or Not
        // somebody valuteer to the be a delegate
        
        // check if medication is not nil b
        guard let medication = medication else { return }
        wasTakenToday.toggle() // toggle() to switch to true or false
        
        delegate?.medicationWasTakenTapped(wasTaken: wasTakenToday, medication: medication)
    }
    
    // MARK: - Helper Fuctions
    // We refactor the updateViews to configure(with medication:...)
    func configure(with medication: Medication) {
        
        // assign the self to medication
        self.medication = medication
        
        // update wasTakenTotoday
        // let takenDates = medication.takenDates // come in Set Then We write the wasTakenToday() function in Medication Class.
        
        // Using the function wasTakenToday from Medication Class to assign the value
        wasTakenToday = medication.wasTakenToday()
        
        
        medicationNameLabel.text = medication.name
        
        //Create Helpers folder and create the DateFormatter then use in here.
        medicationTimeLabel.text = DateFormatter.medicationTime.string(from:  medication.timeOfDay ?? Date())
        
        // Using Ternary Operator to use in SetImage
        let image = wasTakenToday ? UIImage(systemName: "checkmark.square") : UIImage(systemName: "square")
        
        //Using the hasTakenButton to setImage
        hasTakenButton.setImage(image, for: .normal)
        
        // Set tintColor for image
        hasTakenButton.tintColor = .systemIndigo
    }
}
