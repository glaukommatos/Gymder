//
//  SmokeTests.swift
//  GymderUITests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest

/**

    Not really testing much here, just a quick smoke-test.
    Would be fairly straightforward to setup maybe a test
    data source or something to do this in a more controlled
    way so that we might have some more meaningful assertions.
    Most of this behavior ought to be  tested at the unit-level though,
    so I probably would not go too crazy writing lots of UI tests (for
    this particular app).

 */

class SmokeTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testSwipingSmokeTest() {
        let app = XCUIApplication()
        app.launch()

        let topCard = app.otherElements["card"].firstMatch

        if topCard.waitForExistence(timeout: 5) {
            while !app.staticTexts["It's a match!"].exists {
                topCard.swipeRight()
            }

            app.buttons["Awesome!"].tap()

            topCard.swipeLeft()
        } else {
            XCTFail("Card never appeared")
        }
    }

    func testButtonSmokeTest() {
        let app = XCUIApplication()
        app.launch()

        let topCard = app.otherElements["card"].firstMatch
        let swipeRightButton = app.buttons["swipeRight"].firstMatch
        let swipeLeftButton = app.buttons["swipeLeft"].firstMatch

        if topCard.waitForExistence(timeout: 5) {
            while !app.staticTexts["It's a match!"].exists {
                swipeRightButton.tap()
            }

            app.buttons["Awesome!"].tap()
            swipeLeftButton.tap()
        }
    }

    func testInfiniteRunForProfiling() {
        let app = XCUIApplication()
        app.launch()

        let topCard = app.otherElements["card"].firstMatch
        let swipeRightButton = app.buttons["swipeRight"].firstMatch
        let swipeLeftButton = app.buttons["swipeLeft"].firstMatch

        while topCard.waitForExistence(timeout: 5) {
            while !app.staticTexts["It's a match!"].exists {
                swipeRightButton.tap()
            }

            app.buttons["Awesome!"].tap()
            swipeLeftButton.tap()
        }
    }
}
