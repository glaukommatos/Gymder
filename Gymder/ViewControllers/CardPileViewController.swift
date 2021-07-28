//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

class CardPileViewModel {
    @Published var gyms = [Gym]()
}

class CardPileViewController: UIViewController, CardChoiceDelegate, CLLocationManagerDelegate {
    var viewModel = CardPileViewModel()

    var cardPileView: CardPileView!
    let dataSource: CardDataSourceProtocol

    init(dataSource: CardDataSourceProtocol) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        cardPileView = CardPileView(frame: UIScreen.main.bounds)
        self.view = cardPileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardPileView.cardChoiceDelegate = self
        cardPileView.cardDataSource = dataSource

        loadData()
    }

    private func loadData() {
        dataSource.load { error in
            if error == nil {
                DispatchQueue.main.async {
                    self.cardPileView.reload()
                }
            } else {
                DispatchQueue.main.async {
                    let errorVC = ErrorViewController()
                    errorVC.retryHandler = { [weak self] in
                        self?.loadData()
                        self?.dismiss(animated: true, completion: nil)
                    }

                    self.present(errorVC, animated: true, completion: nil)
                }
            }
        }
    }

    func accept() {
        if Int.random(in: 0..<20) == 0 {
            present(MatchViewController(), animated: true, completion: nil)
        }
    }
}
