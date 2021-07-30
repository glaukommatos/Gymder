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
    private let dataProvider: DataProviderProtocol
    private var currentLocation: CLLocation?
    private var gyms = [Gym]()
    private var lock = NSLock()

    weak var delegate: CardPileViewModelDelegate?

    init(
        gymRepository: GymRepositoryProtocol,
        locationProvider: LocationProvider,
        dataProvider: DataProviderProtocol
    ) {
        self.gymRepository = gymRepository
        self.locationProvider = locationProvider
        self.dataProvider = dataProvider
    }

    func load() {
        locationProvider.getCurrentLocation { [weak self] location in
            self?.currentLocation = location

            self?.gymRepository.getGyms { result in
                switch result {
                case .success(let gyms):
                    self?.gyms = gyms.shuffled()
                    self?.delegate?.update(error: nil)
                case .failure(let error):
                    self?.delegate?.update(error: error)
                }
            }
        }
    }

    func next(completion: @escaping (Card?) -> Void) {
        lock.lock()
        let gym = gyms.popLast()
        lock.unlock()

        if let gym = gym {
            dataProvider.download(url: gym.imageUrl) { [weak self] result in
                let imageData: Data?

                switch result {
                case .success(let data):
                    imageData = data
                case .failure:
                    imageData = nil
                }

                let gymLocation = CLLocation(latitude: gym.latitude, longitude: gym.longitude)
                let distance = gymLocation.formattedDistanceTo(self?.currentLocation)
                let card = Card(title: gym.name, distance: distance, imageData: imageData)
                completion(card)
            }
        } else {
            completion(nil)
        }
    }
}
