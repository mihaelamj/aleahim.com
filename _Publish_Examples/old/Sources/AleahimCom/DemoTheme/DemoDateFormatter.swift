//
//  AleahimDateFormatter.swift
//  
//
//  Created by Mihaela MJ on 05.04.2024..
//

import Foundation

extension DateFormatter {
    static var publishSite: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
}
