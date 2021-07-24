//
//  MatchViewTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
@testable import Gymder

class MatchViewTests: XCTestCase {

    func testAddsSubviews() throws {
        let matchView = MatchView()

        XCTAssertTrue(matchView.stackView.subviews.contains(where: { view in
            guard let label = view as? UILabel else { return false }

            return label.text == "It's a match!"
        }))

        XCTAssertTrue(matchView.stackView.subviews.contains(where: { view in
            guard let button = view as? UIButton else { return false }

            return button.titleLabel!.text == "Awesome!"
        }))
    }

    func testInvokesCloseHandler() throws {
        let expectation = XCTestExpectation()
        let matchView = MatchView()
        matchView.closeHandler = {
            expectation.fulfill()
        }

        let button = matchView.stackView.subviews.first { view in
            let button = view as? UIButton
            return button != nil
        } as! UIButton

        button.sendActions(for: .touchUpInside)

        wait(for: [expectation], timeout: 1)
    }
}
