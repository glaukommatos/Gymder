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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = constructVC()
        window?.makeKeyAndVisible()

        return true
    }

    func constructVC() -> MainViewController {
        let locationProvider = LocationProvider()
        let gymService = GymService(
            urlSessionWrapper: URLSessionWrapper(),
            partnersResponseMapper: PartnersResponseMapper()
        )

        let dataSource = CardDataSourceImpl(
            gymService: gymService,
            locationProvider: locationProvider
        )

        let mainVC = MainViewController(
            dataSource: dataSource
        )

        return mainVC
    }
}
