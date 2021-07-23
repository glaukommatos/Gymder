//
//  MainViewController.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class MainViewController: UIViewController, CardChoiceDelegate {
    func accept() {
        present(MatchViewController(), animated: true, completion: nil)
    }

    func reject() {}

    override func loadView() {
        self.view = CardPileView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cards = [
            Card(title: "Gym 1", distance: "4.5 km"),
            Card(title: "Gym 2", distance: "6.3 km"),
            Card(title: "Gym 3", distance: "2.3 km"),
            Card(title: "Gym 4", distance: "1.3 km"),
            Card(title: "Gym 5", distance: "1.4 km"),
            Card(title: "Gym 6", distance: "1.4 km"),
            Card(title: "Gym 7", distance: "2.4 km")
        ]

        if let view = view as? CardPileView {
            view.cards = cards
            view.cardChoiceDelegate = self
        }
    }
}
