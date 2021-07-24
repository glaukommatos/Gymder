//
//  CardViewTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
@testable import Gymder

class CardViewTests: XCTestCase {

    func testAddsLabels() throws {
        let card = Card(title: "Title", distance: "x km", url: URL(string: "http://valid.url.com/")!)
        let view = CardView(frame: .zero)
        view.card = card

        XCTAssertTrue(view.subviews.contains { view in
            guard let label = view as? UILabel else { return false }
            return label.text == "Title"
        })

        XCTAssertTrue(view.subviews.contains { view in
            guard let label = view as? UILabel else { return false }
            return label.text == "x km"
        })
    }
}
