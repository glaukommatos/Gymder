//
//  MatchViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

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
