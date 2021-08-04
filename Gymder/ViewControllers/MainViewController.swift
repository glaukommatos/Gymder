//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

/**

    Here's where a fair amount of the magic happens.

    The `MainViewController` owns a few controllers
    which it can present:
        `MatchViewController` for when there is a match, and
        `ErrorViewController` for when there is a (network) error.

    The `CardPileViewModel` is here to try to keep the view controller
    from having to do too much work. This view controller implements the
    `CardPileViewModelDelegate` in order to recieve updates from
    the view model whenever there the data from the backend has been
    loaded. It also finds out from thsis delegate when the view model is
    "ready". The `CardPileViewModel` finds out when it's ready
    from the `CardPileView`. Readiness in this case is meant to
    express whether or not the UI is in a state that it should accept
    input from the user (we want the `ChoiceBar` disabled if there
    are no cards available, for example).

    It also implements `CardPileChoiceDelegate` to recieve
    updates from the `CardPileView`, which is the actual
    source of the choices that the user makes. When the user
    uses the `ChoiceBar` to swipe left or right, it is actually
    just delegating this to the `CardPileView`. This might be
    a little bit strange, and I'm still considering other ways to do
    this, but it made it easier to keep the two in sync. At the end
    of the day, right now, it's the `CardPileView` that is the
    owner of swiping, and it is the `CardPileView` which
    actually sends out the canonical `accept` and `reject`
    that is used to communicate a choice by the user. I think it
    would be preferable in the future to move this one level higher,
    so that the `CardPileView` and its view model aren't  owning
    this shared data. If I wasn't trying to finish this up before Monday,
    I'd spent more time to change the structure of this a bit because
    I think a better abstraction  is possible. A fair bit of the current
    design grew out of wanting  to add the `ChoiceBar` in
    somewhat at the last minute, but now that it's working, this
    would be a good time to rethink the structure a little bit.

 */

class MainViewController: UIViewController, CardPileViewModelDelegate, ChoiceBarDelegate {
    private lazy var mainView = MainView()
    private let viewModel: CardPileViewModel
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

    init(
        viewModel: CardPileViewModel
    ) {
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
            // that's 5%, right?
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
}
