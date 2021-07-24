//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController, CardChoiceDelegate, CLLocationManagerDelegate {
    let dataSource: CardDataSource

    init(dataSource: CardDataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var cardPileView: CardPileView {
        view as! CardPileView
    }

    override func loadView() {
        self.view = CardPileView(frame: UIScreen.main.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardPileView.cardChoiceDelegate = self
        cardPileView.cardDataSource = dataSource
        dataSource.cardPileView = cardPileView

        dataSource.load()
    }

    func accept() {
        if Int.random(in: 0..<20) == 0 {
            present(MatchViewController(), animated: true, completion: nil)
        }
    }
}
