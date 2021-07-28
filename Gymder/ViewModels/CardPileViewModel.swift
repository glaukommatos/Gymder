//
//  CardPileViewModel.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation
import CoreLocation

/**

    This one was pretty fun. The ViewController can setup this
    view model with a delegate and then that delgate will get
    updated when there are new `Cards` waiting.

    It also implements `CardDataSourceProtocol` so that
    the `CardPileView` can query it for additional cards which
    can then be swiped by the user.

 */

class CardPileViewModel: CardDataSourceProtocol {
    private let gymRepository: GymRepositoryProtocol
    private let locationProvider: LocationProvider

    weak var delegate: CardPileViewModelDelegate?

    private var cards = [Card]()

    init(gymRepository: GymRepositoryProtocol, locationProvider: LocationProvider) {
        self.gymRepository = gymRepository
        self.locationProvider = locationProvider
    }

    func load() {
        locationProvider.getCurrentLocation { [weak self] location in
            guard let self = self else { return }
            self.gymRepository.getGyms { result in
                switch result {
                case .success(let gyms):
                    self.cards = gyms.shuffled().map({ self.map(gym: $0, withUserLocation: location) })
                    self.delegate?.update(error: nil)
                case .failure(let error):
                    self.delegate?.update(error: error)
                }
            }
        }
    }

    func next() -> Card? {
        cards.popLast()
    }

    private func map(gym: Gym, withUserLocation userLocation: CLLocation?) -> Card {
        if let userLocation = userLocation {
            let gymLocation = CLLocation(latitude: gym.latitude, longitude: gym.longitude)
            let distance = gymLocation.formattedDistanceTo(userLocation)
            return Card(title: gym.name, distance: distance, url: gym.imageUrl)
        } else {
            return Card(title: gym.name, distance: "...", url: gym.imageUrl)
        }
    }
}
