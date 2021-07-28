//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

class CardPileViewController: UIViewController, CardChoiceDelegate, CardPileViewModelDelegate {
    var cardPileView: CardPileView!
    let viewModel: CardPileViewModel

    init(viewModel: CardPileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Gymber"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        cardPileView = CardPileView()
        self.view = cardPileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        cardPileView.cardChoiceDelegate = self
        cardPileView.cardDataSource = viewModel
        viewModel.delegate = self

        viewModel.load()
    }

    func update(error: GymRepositoryError?) {
        if error == nil {
            DispatchQueue.main.async {
                self.cardPileView.reload()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                let errorViewController = ErrorViewController()
                errorViewController.retryHandler = { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    self?.viewModel.load()
                }

                self?.present(errorViewController, animated: true, completion: nil)
            }
        }
    }

    func accept() {
        if Int.random(in: 0..<20) == 0 {
            present(MatchViewController(), animated: true, completion: nil)
        }
    }
}
