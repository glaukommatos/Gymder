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
        registerDependencies()
        createRootVC()

        return true
    }

    private func createRootVC() {
        window = UIWindow()
        window?.rootViewController = Container.shared.get(instanceOf: CardPileViewController.self)
        window?.makeKeyAndVisible()
    }

    private func registerDependencies() {
        Container.shared.register(for: CardPileViewController.self) { container in
            CardPileViewController(viewModel: container.get(instanceOf: CardPileViewModel.self))
        }

        Container.shared.register(for: LocationProvider.self) { _ in
            LocationProvider()
        }

        Container.shared.register(for: CardPileViewModel.self) { container in
            CardPileViewModel(
                gymRepository: container.get(instanceOf: GymRepositoryProtocol.self),
                locationProvider: container.get(instanceOf: LocationProvider.self))
        }

        Container.shared.register(for: GymRepositoryProtocol.self) { container in
            GymRepository(
                urlSessionWrapper: container.get(instanceOf: DataProviderProtocol.self),
                partnersResponseMapper: container.get(instanceOf: PartnersResponseMapperProtocol.self)
            )
        }

        Container.shared.register(for: DataProviderProtocol.self) { _ in
            DataProvider()
        }

        Container.shared.register(for: PartnersResponseMapperProtocol.self) { _ in
            PartnersResponseMapper()
        }

        Container.shared.register(for: LocationProvider.self) { _ in
            LocationProvider()
        }
    }
}
