//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class MainViewController: UIViewController, CardPileViewModelDelegate, CardPileChoiceDelegate, ChoiceBarDelegate {
    private lazy var mainView = MainView()
    private let viewModel: CardPileViewModel
    private let matchViewController: MatchViewController
    private let errorViewController: ErrorViewController

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

        viewModel.delegate = self
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
    }

    override func viewDidAppear(_ animated: Bool) {
        viewModel.load()
    }

    // MARK: CardPileViewModelDelegate

    func cardPileViewModel(_ cardPileViewModel: CardPileViewModel, didFinishLoadingWithError error: Error?) {
        if error == nil {
            self.mainView.cardPileView.load()
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.present(self.errorViewController, animated: true)
            }
        }
    }

    func cardPileViewModel(_ cardPileViewModel: CardPileViewModel, didChangeReadiness ready: Bool) {
        DispatchQueue.main.async { [weak self] in
            self?.mainView.choiceBar.isEnabled = ready
        }
    }

    // MARK: ChoiceBarDelegate

    func choiceBar(_ choiceBar: ChoiceBarView, didChoose choice: Choice) {
        switch choice {
        case .accept:
            mainView.cardPileView.swipeTopCard(direction: .right)
        case .reject:
            mainView.cardPileView.swipeTopCard(direction: .left)
        }
    }

    // MARK: CardChoiceDelegate

    func cardPile(_ cardPileView: CardPileView, didChoose choice: Choice) {
        switch choice {
        case .accept:
            if Int.random(in: 0..<20) == 0 {
                present(matchViewController, animated: true, completion: nil)
            }
        case .reject:
            return
        }
    }
}
