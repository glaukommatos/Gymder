//
//  AppDelegate.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow()
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        return true
    }

    lazy var mainViewController: MainViewController = {
        let dataProvider = DataProvider()
        let cardPileViewModel = CardPileViewModel(
            gymRepository: GymRepository(
                urlSessionWrapper: dataProvider,
                partnersResponseMapper: PartnersResponseMapper()
            ),
            locationProvider: LocationProvider(),
            dataProvider: dataProvider
        )

        return MainViewController(viewModel: cardPileViewModel)
    }()
}
