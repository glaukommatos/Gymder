//
//  CLLocationFormattedDistanceExtension.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

extension CLLocation {
    func formattedDistanceTo(_ location: CLLocation?) -> String {
        guard let location = location else { return "..." }

        let distance = self.distance(from: location)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long
        formatter.numberFormatter.maximumFractionDigits = 2

        return formatter.string(from: Measurement(value: distance, unit: UnitLength.meters))
    }
}
