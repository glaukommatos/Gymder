//
//  CardDataSource.swift
//  Gymder
//
//  Created by Kyle Pointer on 24.07.21.
//

import Foundation
import CoreLocation

class CardDataSourceImpl: CardDataSource {
    let gymService: GymServiceProtocol
    let locationProvider: LocationProvider
    
    var cardPileView: CardPileView?
    
    var gyms = [Gym]()
    var currentLocation: CLLocation?
    
    init(gymService: GymServiceProtocol,
         locationProvider: LocationProvider
    ) {
        self.gymService = gymService
        self.locationProvider = locationProvider
    }
    
    func load() {
        locationProvider.getCurrentLocation { [weak self] location in
            if let self = self {
                self.currentLocation = location
                self.gymService.getGyms { gyms in
                    if let gyms = gyms {
                        self.gyms = gyms.shuffled()
                    }

                    DispatchQueue.main.async {
                        self.cardPileView?.reload()
                    }
                }
            }
        }
    }

    func next() -> Card? {
        if let gym = gyms.popLast() {
            if let currentLocation = currentLocation {
                return Card(title: gym.name, distance: currentLocation.formattedDistanceTo(CLLocation(latitude: gym.latitude, longitude: gym.longitude)), url: gym.imageUrl)
            } else {
                return Card(title: gym.name, distance: "...", url: gym.imageUrl)
            }
        } else {
            return nil
        }
    }
}
