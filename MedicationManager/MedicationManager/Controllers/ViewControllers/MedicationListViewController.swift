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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // MedicationController.shared.fetchMedications() >> DO NOT NEED IT HERE, just call it at viewWillAppear
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //The orders are very important. Here we need to fetch before reload it.
        MedicationController.shared.fetchMedications()
        tableView.reloadData()
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
    
    // getting title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not taken"
        } else {
            return "Taken"
        }
        
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
}
