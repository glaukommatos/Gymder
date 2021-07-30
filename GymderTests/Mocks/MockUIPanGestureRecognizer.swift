//
//  MockUIPanGestureRecognizer.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
import UIKit
@testable import Gymder

class MockUIPanGestureRecognizer: UIPanGestureRecognizer {
    var xTranslation = 0
    var theView: UIView?

    override var view: UIView? {
        theView
    }

    override func translation(in view: UIView?) -> CGPoint {
        CGPoint(x: xTranslation, y: 0)
    }
}
