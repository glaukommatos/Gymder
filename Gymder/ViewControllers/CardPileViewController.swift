//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

/**

    Here's where a lot of things come together.

    This `CardPileViewController` manages a
    `CardPileView` and listens to changes from the
    `CardPileViewModelDelegate` and to selections
    from the `CardChoiceDelegate`.

    In order to keep a lot of extra cruft out of here, I've
    implemented the MVVM pattern (or at least something
    like it). This way this view controller can focus on what
    it really loves to do– *presenting other view controllers*.

 */

class CardPileViewController: UIViewController, CardChoiceDelegate, CardPileViewModelDelegate {
    private var cardPileView: CardPileView!
    private let errorViewController: ErrorViewController
    private let viewModel: CardPileViewModel
    private let matchViewController: MatchViewController

    init(
        viewModel: CardPileViewModel,
        errorViewController: ErrorViewController,
        matchViewController: MatchViewController
    ) {
        self.viewModel = viewModel
        self.errorViewController = errorViewController
        self.matchViewController = matchViewController
        super.init(nibName: nil, bundle: nil)
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

        viewModel.delegate = self
        cardPileView.cardChoiceDelegate = self
        cardPileView.cardDataSource = viewModel
        errorViewController.retryHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            self?.viewModel.load()
        }

        matchViewController.closeHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.load()
    }

    // MARK: CardPileViewModelDelegate

    func update(error: GymRepositoryError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if error == nil {
                self.cardPileView.load()
            } else {
                self.present(self.errorViewController, animated: true, completion: nil)
            }
        }
    }

    // MARK: CardChoiceDelegate

    func accept() {
        if Int.random(in: 0..<20) == 0 {
            present(matchViewController, animated: true, completion: nil)
        }
    }
}
