//
//  CLLocationFormattedDistanceExtension.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

extension CLLocation {
    func formattedDistanceTo(_ location: CLLocation) -> String {
        let distance = self.distance(from: location)
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .long

        return formatter.string(from: Measurement(value: distance, unit: UnitLength.meters))
    }
}
