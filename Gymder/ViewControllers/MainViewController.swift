//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class MainViewController: UIViewController, CardChoiceDelegate, CardPileViewModelDelegate, ChoiceBarDelegate {
    let mainView = MainView()
    let viewModel: CardPileViewModel
    let matchViewController: MatchViewController
    let errorViewController: ErrorViewController

    init(
        matchViewController: MatchViewController,
        errorViewController: ErrorViewController,
        viewModel: CardPileViewModel
    ) {
        self.matchViewController = matchViewController
        self.errorViewController = errorViewController
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.choiceBar.delegate = self
        mainView.cardPileView.cardChoiceDelegate = self
        mainView.cardPileView.cardDataSource = viewModel
        mainView.cardPileView.cardPileReadinessDelegate = viewModel

        matchViewController.closeHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }

        errorViewController.retryHandler = { [weak self] in
            self?.dismiss(animated: true) {
                self?.viewModel.load()
            }
        }

        viewModel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.load()
    }

    // MARK: CardPileViewModelDelegate

    func finishedLoading(error: GymRepositoryError?) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if error == nil {
                self.mainView.cardPileView.load()
            } else {
                self.present(self.errorViewController, animated: true, completion: nil)
            }
        }
    }

    func ready(_ isReady: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.mainView.choiceBar.buttonContainer.leftButton.isEnabled = isReady
            self?.mainView.choiceBar.buttonContainer.rightButton.isEnabled = isReady
        }
    }

    // MARK: ChoiceBarDelegate

    func accept(choiceBar: ChoiceBar) {
        mainView.cardPileView.swipeTopCard(direction: .right)
    }

    func reject(choiceBar: ChoiceBar) {
        mainView.cardPileView.swipeTopCard(direction: .left)
    }

    // MARK: CardChoiceDelegate

    func accept() {
        if Int.random(in: 0..<20) == 0 {
            present(matchViewController, animated: true, completion: nil)
        }
    }

    func reject() {}
}
