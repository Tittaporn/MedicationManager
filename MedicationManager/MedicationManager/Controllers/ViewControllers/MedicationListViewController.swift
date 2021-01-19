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
            let medication = MedicationController.shared.medications[indextPath.row]
            destination.medication = medication
        }
    }
}

// MARK: - Extensions
extension MedicationListViewController: UITableViewDelegate {
    
}

extension MedicationListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MedicationController.shared.medications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "medicationCell", for: indexPath) as? MedicationTableViewCell else { return UITableViewCell ()}
        let medication = MedicationController.shared.medications[indexPath.row]
        cell.updateViews(medication: medication)
        return cell
    }
}
