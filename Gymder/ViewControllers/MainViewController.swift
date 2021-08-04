//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class MainViewController: UIViewController, CardPileViewModelDelegate, ChoiceBarDelegate {
    private lazy var mainView = MainView()
    private let viewModel: CardPileViewModel

    init(viewModel: CardPileViewModel) {
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

        setupDelegates()
        viewModel.load()
    }

    func setupDelegates() {
        viewModel.delegate = self
        mainView.choiceBar.delegate = self
        mainView.cardPileView.dataSource = viewModel
        mainView.cardPileView.delegate = viewModel
    }

    func cardPileViewModel(_ cardPileViewModel: CardPileViewModel, didChangeReadiness ready: Bool) {
        mainView.choiceBar.isEnabled = ready
    }

    func cardPileViewModel(_ cardPileViewModel: CardPileViewModel, didChoose choice: CardPileChoice) {
        switch choice {
        case .accept:
            if Int.random(in: 0..<20) == 0 {
                present(matchViewController, animated: true, completion: nil)
            }
        case .reject:
            return
        }
    }

    func cardPileViewModel(_ cardPileViewModel: CardPileViewModel, didFinishLoadingWithError error: Error?) {
        guard error == nil else {
            self.present(self.errorViewController, animated: true)
            return
        }

        self.mainView.cardPileView.load()
    }

    func choiceBar(_ choiceBar: ChoiceBarView, didChoose choice: CardPileChoice) {
        switch choice {
        case .accept:
            mainView.cardPileView.swipeTopCard(direction: .right)
        case .reject:
            mainView.cardPileView.swipeTopCard(direction: .left)
        }
    }

    private var matchViewController: MatchViewController {
        MatchViewController()
    }

    private var errorViewController: ErrorViewController {
        let errorViewController = ErrorViewController()
        errorViewController.retryHandler = { [weak self] in
            self?.viewModel.load()
        }
        return errorViewController
    }
}
