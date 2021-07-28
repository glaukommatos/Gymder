//
//  SmokeTests.swift
//  GymderUITests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest

class SmokeTests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    // Not really testing much here, just a quick smoke-test.
    // Would be fairly straightforward to setup maybe a test
    // data source or something to do this in a more controlled
    // way so that we might have some more meaningful assertions.
    //
    // Most of this behavior is tested at the unit-level though, so
    // I probably would not go too crazy writing lots of UI tests.
    func testSmokeTest() throws {
        let app = XCUIApplication()
        app.launch()

        let topCard = app.otherElements["card"].firstMatch

        if topCard.waitForExistence(timeout: 15) {
            while !app.staticTexts["It's a match!"].exists {
                topCard.swipeRight()
            }

            app.buttons["Awesome!"].tap()

            topCard.swipeLeft()
        } else {
            XCTFail("Card never appeared")
        }
    }
}
