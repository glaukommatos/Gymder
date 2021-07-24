//
//  MatchViewController.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class MatchViewController: UIViewController {
    override func loadView() {
        self.view = MatchView()
    }

    override func viewDidLoad() {
        setCloseHandler()
    }

    private func setCloseHandler() {
        if let matchView = view as? MatchView {
            matchView.closeHandler = { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
