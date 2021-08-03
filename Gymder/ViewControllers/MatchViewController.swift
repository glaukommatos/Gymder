//
//  MatchViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

/**

    There's not that much going on here, mostly just presenting a cute little
    match view and letting you dismiss it.

 */

class MatchViewController: UIViewController {
    private lazy var matchView = MatchView()

    override func loadView() {
        view = matchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        matchView.closeHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        matchView.stopAnimations()
    }

    override func viewWillAppear(_ animated: Bool) {
        matchView.updateBalls()
        matchView.startAnimation()
    }
}
