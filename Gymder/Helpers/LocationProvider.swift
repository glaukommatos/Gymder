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
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func getCurrentLocation(completion: @escaping (CLLocation?) -> Void) {
        self.callback = completion

        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            executeThenDisableCallback(location: nil)
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func executeThenDisableCallback(location: CLLocation?) {
        callback?(location)
        callback = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .restricted:
            executeThenDisableCallback(location: nil)
        default:
            return
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        executeThenDisableCallback(location: locations.last)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let error = error as? CLError else { return }

        switch error.code {
        case .locationUnknown:
            return
        default:
            locationManager.stopUpdatingLocation()
            executeThenDisableCallback(location: nil)
        }
    }
}
