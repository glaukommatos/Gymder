//
//  ErrorViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import UIKit

/**

    Just in case the user is apparently offline or something
    because we're not getting anything useful from the
    `GymRepository`, we'll present this and at least
    give them something to click on until they disable
    airplane mode.

 */

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