//
//  ErrorViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import UIKit

class ErrorViewController: UIViewController {
    private lazy var errorView = ErrorView()
    var retryHandler: (() -> Void)?

    override func loadView() {
        view = errorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        errorView.closeHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        retryHandler?()
    }
}
