//
//  ChoiceBarController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class ChoiceBarController: UIViewController {
    var choiceBarView: ChoiceBar!

    override func loadView() {
        choiceBarView = ChoiceBar()
        view = choiceBarView
    }
}
