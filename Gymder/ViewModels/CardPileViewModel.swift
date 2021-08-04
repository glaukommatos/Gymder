//
//  CardPileViewModel.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import Foundation
import CoreLocation

class CardPileViewModel: CardPileDataSource, CardPileViewDelegate {
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
                DispatchQueue.main.async {
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

    func cardPileView(_ cardPileView: CardPileView, didChangeReadiness ready: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.delegate?.cardPileViewModel(self, didChangeReadiness: ready)
        }
    }

    func cardPileView(_ cardPileView: CardPileView, didChoose choice: CardPileChoice) {
        delegate?.cardPileViewModel(self, didChoose: choice)
    }

    func cardPileViewDidRunOutOfCards(_ cardPileView: CardPileView) {
        load()
    }
}
