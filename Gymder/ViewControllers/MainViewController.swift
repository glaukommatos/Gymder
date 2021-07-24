//
//  MainViewController.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CardChoiceDelegate, CLLocationManagerDelegate {
    let locationService = LocationProvider()

    override func loadView() {
        self.view = CardPileView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = view as? CardPileView {
            view.cardChoiceDelegate = self
        }

        locationService.getCurrentLocation { [weak self] location in
            self?.loadGyms(with: location)
        }
    }

    private func loadGyms(with currentLocation: CLLocation?) {
        if let view = view as? CardPileView {
            let gymService = GymService(urlSessionWrapper: URLSessionWrapper(), partnersResponseMapper: PartnersResponseMapper())

            gymService.getGyms { gyms in
                DispatchQueue.main.async {
                    view.cards = gyms!.map { gym in
                        if let currentLocation = currentLocation {
                            return Card(title: gym.name, distance: currentLocation.formattedDistanceTo(CLLocation(latitude: gym.latitude, longitude: gym.longitude)), url: gym.imageUrl)
                        } else {
                            return Card(title: gym.name, distance: "...", url: gym.imageUrl)
                        }

                    }.shuffled()
                }
            }
        }
    }

    // MARK: - CardChoiceDelegate

    func accept() {
        present(MatchViewController(), animated: true, completion: nil)
    }

    func reject() {}
}
