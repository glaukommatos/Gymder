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
    var cardPileView: CardPileView!
    let viewModel: CardPileViewModel

    private var errorViewController: ErrorViewController {
        let errorViewController = ErrorViewController()
        errorViewController.retryHandler = { [weak self] in
            self?.dismiss(animated: true)
            self?.viewModel.load()
        }
        return errorViewController
    }

    private var matchViewController: MatchViewController {
        MatchViewController()
    }

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

    // MARK: CardPileViewModelDelegate

    func update(error: GymRepositoryError?) {
        if error == nil {
            DispatchQueue.main.async {
                self.cardPileView.reload()
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
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
