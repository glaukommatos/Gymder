//
//  AppDelegate.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow()
        window?.rootViewController = MainViewController()
        window?.makeKeyAndVisible()

        return true
    }
}
