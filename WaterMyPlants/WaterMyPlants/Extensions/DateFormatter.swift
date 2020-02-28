//
//  DateFormatter.swift
//  WaterMyPlants
//
//  Created by Craig Swanson on 2/27/20.
//  Copyright © 2020 craigswanson. All rights reserved.
//

import Foundation

extension Date {
    static func stringFormattedDate(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        return dateFormatter.string(from: date)
    }
}
