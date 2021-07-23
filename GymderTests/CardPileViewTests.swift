//
//  CardPileViewTests.swift
//  TestingTestingTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
@testable import Gymder

class CardPileViewTests: XCTestCase {

    func testDisplaysAndMaintainsThreeCards() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1"),
            Card(title: "Card 2", distance: "Distance 2"),
            Card(title: "Card 3", distance: "Distance 3"),
            Card(title: "Card 4", distance: "Distance 4")
        ]

        let view = CardPileView()
        view.cards = cards

        XCTAssertEqual(view.subviews.count, 3)

        let expectation = XCTestExpectation()

        view.pan(sender: self.swipeRight(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(view.subviews.count, 3)
            view.pan(sender: self.swipeRight(card: view.subviews.last!))

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(view.subviews.count, 2)
                XCTAssertEqual(view.subviews.last!.gestureRecognizers?.count, 1)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testRefreshesViewWhenCardsPropertyIsSet() {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1")
        ]

        let view = CardPileView()
        view.cards = cards

        XCTAssertEqual(view.subviews.count, 1)

        view.cards = []

        XCTAssertEqual(view.subviews.count, 0)
    }

    func testEmptyOnceWeRunOutOfCards() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1")
        ]

        let view = CardPileView()
        view.cards = cards

        let expectation = XCTestExpectation()

        view.pan(sender: self.swipeRight(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(view.subviews.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCentersCardAgainIfGestureEndsWithoutDoingAnything() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1")
        ]

        let view = CardPileView()
        view.cards = cards

        let expectation = XCTestExpectation()

        view.pan(sender: self.swipeButNotEnough(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(view.subviews.first!.transform, .identity)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCardPanning() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1")
        ]

        let view = CardPileView()
        view.cards = cards

        view.pan(sender: self.swipeAndHold(card: view.subviews.last!))

        XCTAssertNotEqual(view.subviews.first!.transform, .identity)
    }

    func testMatchAccept() {
        let cards = [
            Card(title: "Gym 1", distance: "Distance 1")
        ]

        let mockDelegate = MockCardChoiceDelegate()

        let view = CardPileView()
        view.cardChoiceDelegate = mockDelegate
        view.cards = cards

        let topCard = view.subviews.last!

        view.pan(sender: swipeRight(card: topCard))

        XCTAssertEqual(mockDelegate.lastChoice, .accept)
    }

    func testMatchReject() {
        let cards = [
            Card(title: "Gym 1", distance: "Distance 1")
        ]

        let mockDelegate = MockCardChoiceDelegate()

        let view = CardPileView()
        view.cardChoiceDelegate = mockDelegate
        view.cards = cards

        let topCard = view.subviews.last!

        view.pan(sender: swipeLeft(card: topCard))

        XCTAssertEqual(mockDelegate.lastChoice, .reject)
    }

    private func swipeLeft(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = -300
        gesture.state = .ended

        return gesture
    }

    private func swipeRight(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = 300
        gesture.state = .ended

        return gesture
    }

    private func swipeButNotEnough(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = 0
        gesture.state = .ended

        return gesture
    }

    private func swipeAndHold(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = 10
        gesture.state = .changed

        return gesture
    }
}

private class MockCardChoiceDelegate: CardChoiceDelegate {
    enum Choice {
        case accept
        case reject
        case none
    }

    var lastChoice = Choice.none

    func accept() {
        lastChoice = .accept
    }

    func reject() {
        lastChoice = .reject
    }
}

private class MockUIPanGestureRecognizer: UIPanGestureRecognizer {
    var xTranslation = 0
    var theView: UIView?

    override func translation(in view: UIView?) -> CGPoint {
        CGPoint(x: xTranslation, y: 0)
    }

    override var view: UIView? {
        theView
    }
}
