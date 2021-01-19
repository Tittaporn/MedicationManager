//
//  DateFormatterExtension.swift
//  MedicationManager
//
//  Created by Lee McCormick on 1/18/21.
//

import Foundation

extension DateFormatter { //This is swift class from Apple.
    static let medicationTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
}
