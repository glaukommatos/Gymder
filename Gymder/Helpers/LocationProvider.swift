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

    var attemptAlreadyMade = false
    var cachedLocation: CLLocation?

    override init() {
        super.init()

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        print("\(Date()): getCurrentLocation")
        if attemptAlreadyMade {
            completion(cachedLocation)
        } else {
            self.callback = completion
            locationManager.requestWhenInUseAuthorization()
            attemptAlreadyMade = true
        }
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
        cachedLocation = locations.last
        print("\(Date()): got location")
        callback?(cachedLocation)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }

        switch error.code {
        case .locationUnknown:
            return
        default:
            locationManager.stopUpdatingLocation()
            callback?(nil)
        }
    }
}
