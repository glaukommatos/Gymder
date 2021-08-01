//
//  MockCardChoiceDelegate.swift
//  GymderTests
//
//  Created by Kyle Pointer on 30.07.21.
//

import Foundation
@testable import Gymder

class MockCardChoiceDelegate: CardChoiceDelegate {
    enum Choice {
        case accept
        case none
    }

    var lastChoice = Choice.none

    func accept() {
        lastChoice = .accept
    }

    func reject() {
        lastChoice = .none
    }
}
