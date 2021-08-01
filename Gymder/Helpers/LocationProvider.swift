//
//  LocationProvider.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

/**

    Provides the user's current location after going through
    `CLLocationManager`'s song and dance.

    If location permission is granted and a location can be
    determined, then it is returned and the location manager's
    updates will be stopped.

    If location permission is not granted, or if an error occurs
    that would indicate it's not going to happen (as far as I know),
    then the callback will be called with `nil`.

    # Important Note

    The method `locationManager(_:didUpdateLocations:)`
    can be called even after we ask to stop receiving updates.

    For this reason we also set the callback to `nil`.
    We want `getCurrentLocation(completion:)` to return *only once*.

 */

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

    // MARK: CLLocationManagerDelegate

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
