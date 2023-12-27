//
//  String+Extension.swift
//  TMEvents
//
//  Created by Juan Carlos Carrera Reyes on 25/12/23.
//

import Foundation

extension String {
    func toMonthFormatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: self) {
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "MMM dd yyyy"
            return newDateFormatter.string(from: date)
        }
        return self
    }
}
