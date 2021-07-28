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

    Depending on requirements, this could be changed to give
    a different location each time, rather than a cached one. But
    for the way in which is is consumed in this app, it seems
    prudent just to get the location once at startup.

 */

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
