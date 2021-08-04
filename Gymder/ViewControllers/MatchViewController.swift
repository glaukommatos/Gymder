//
//  MatchViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

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
}
