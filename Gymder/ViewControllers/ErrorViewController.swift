//
//  ErrorViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import UIKit

class ErrorViewController: UIViewController {
    private var errorView: ErrorView!
    var retryHandler: (() -> Void)?

    override func loadView() {
        errorView = ErrorView()
        view = errorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        errorView.retryHandler = retryHandler
    }
}
