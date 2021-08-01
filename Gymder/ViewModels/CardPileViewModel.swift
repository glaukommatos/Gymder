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

class CardPileViewModel: CardDataSourceProtocol, CardPileReadinessDelegate {
    private let gymRepository: GymRepositoryProtocol
    private let locationProvider: LocationProvider
    private let dataProvider: DataProviderProtocol
    private var currentLocation: CLLocation?
    private var gyms = [Gym]()

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
        delegate?.cardPileViewModel(self, didChangeReadiness: false)
        locationProvider.getCurrentLocation { [weak self] location in
            guard let self = self else { return }
            self.currentLocation = location

            self.gymRepository.getGyms { result in
                switch result {
                case .success(let gyms):
                    self.gyms = gyms.shuffled()
                    self.delegate?.cardPileViewModel(self, didFinishLoadingWithError: nil)
                case .failure(let error):
                    self.delegate?.cardPileViewModel(self, didFinishLoadingWithError: error)
                }
            }
        }
    }

    func cardPileView(_ cardPileView: CardPileView, didChangeReadiness ready: Bool) {
        delegate?.cardPileViewModel(self, didChangeReadiness: ready)
    }

    func next(completion: @escaping (Card?) -> Void) {
        if let gym = gyms.popLast() {
            dataProvider.download(url: gym.imageUrl) { [weak self] result in
                guard let self = self else { return }
                let imageData: Data?

                switch result {
                case .success(let data):
                    imageData = data
                case .failure:
                    imageData = nil
                }

                let gymLocation = CLLocation(latitude: gym.latitude, longitude: gym.longitude)
                let distance = gymLocation.formattedDistanceTo(self.currentLocation)
                let card = Card(title: gym.name, distance: distance, imageData: imageData)
                completion(card)
            }
        } else {
            completion(nil)
        }
    }
}
