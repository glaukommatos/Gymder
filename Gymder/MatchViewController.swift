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
        guard let matchView = view as? MatchView else { return }

        matchView.closeHandler = { [weak self] in
            self?.dismiss(animated: true, completion: nil)
        }
    }

    init() {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    required init?(coder: NSCoder) { fatalError() }
}
