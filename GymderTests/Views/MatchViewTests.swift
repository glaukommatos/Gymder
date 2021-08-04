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
        XCTAssertEqual(label?.text, "It's a match!")
        XCTAssertEqual(button?.titleLabel?.text, "Awesome!")
    }

    func testInvokesCloseHandler() throws {
        let expectation = XCTestExpectation()
        matchView.closeHandler = {
            expectation.fulfill()
        }

        button?.sendActions(for: .touchUpInside)

        wait(for: [expectation], timeout: 1)
    }

    lazy var matchView = MatchView()
    lazy var stackView: UIStackView? = {
        guard let stackView = matchView.subviews.first(where: { view in
            view is UIStackView
        }) as? UIStackView else {
            XCTFail("No Stack View")
            return nil
        }

        return stackView
    }()

    lazy var label: UILabel? = {
        if let label = stackView?.subviews.first(where: {
            $0 is UILabel
        }) as? UILabel {
            return label
        } else {
            return nil
        }
    }()

    lazy var button: UIButton? = {
        if let label = stackView?.subviews.first(where: {
            $0 is UIButton
        }) as? UIButton {
            return label
        } else {
            return nil
        }
    }()
}
