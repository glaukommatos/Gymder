//
//  LocationProvider.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

class LocationProvider: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    private var callback: ((CLLocation?) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        self.callback = completion
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied:
            callback?(nil)
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        callback?(locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
    }
}
