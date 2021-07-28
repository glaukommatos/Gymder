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
    private var matchView: MatchView!

    override func loadView() {
        matchView = MatchView()
        view = matchView
    }

    override func viewDidLoad() {
        setCloseHandler()
    }

    private func setCloseHandler() {
        matchView.closeHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
