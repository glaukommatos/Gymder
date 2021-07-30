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
        let exampleImage = UIImage(systemName: "flame")
        let card = Card(title: "Title", distance: "x km", imageData: exampleImage?.pngData())
        let view = CardView(frame: .zero)
        view.card = card

        XCTAssertEqual(view.titleLabel.text, "Title")
        XCTAssertEqual(view.distanceLabel.text, "x km")
        XCTAssertNotNil(view.imageView.image)
    }
}
