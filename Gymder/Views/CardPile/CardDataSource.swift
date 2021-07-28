//
//  CardDataSource.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

enum CardDataSourceErrors: Error {
    case network
}

class CardDataSource: CardDataSourceProtocol {
    let gymRepository: GymRepositoryProtocol
    let locationProvider: LocationProvider

    var gyms = [Gym]()
    var currentLocation: CLLocation?

    init(gymRepository: GymRepositoryProtocol,
         locationProvider: LocationProvider
    ) {
        self.gymRepository = gymRepository
        self.locationProvider = locationProvider
    }

    func load(completion: @escaping (Error?) -> Void) {
        locationProvider.getCurrentLocation { [weak self] location in
            if let self = self {
                self.currentLocation = location
                self.gymRepository.getGyms { gyms in
                    switch gyms {
                    case .success(let gyms):
                        self.gyms = gyms.shuffled()
                        completion(nil)
                    case .failure:
                        completion(CardDataSourceErrors.network)
                    }
                }
            }
        }
    }

    func next() -> Card? {
        if let gym = gyms.popLast() {
            if let currentLocation = currentLocation {
                return Card(
                    title: gym.name,
                    distance: currentLocation.formattedDistanceTo(
                        CLLocation(latitude: gym.latitude, longitude: gym.longitude)
                    ),
                    url: gym.imageUrl)
            } else {
                return Card(title: gym.name, distance: "...", url: gym.imageUrl)
            }
        } else {
            return nil
        }
    }
}
