//
//  CardPileViewTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

import XCTest
@testable import Gymder

class CardPileViewTests: XCTestCase {
    private let validUrl = URL(string: "http://www.url.com/")!
    private var view: CardPileView!
    private var mockDataSource: MockCardDataSource!
    private var mockDelegate: MockCardChoiceDelegate!

    override func setUp() {
        view = CardPileView()
        mockDelegate = MockCardChoiceDelegate()
        mockDataSource = MockCardDataSource()
        view.cardChoiceDelegate = mockDelegate
        view.cardDataSource = mockDataSource
        mockDataSource.cardPileView = view

    }

    func testDisplaysAndMaintainsThreeCards() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", url: validUrl),
            Card(title: "Card 2", distance: "Distance 2", url: validUrl),
            Card(title: "Card 3", distance: "Distance 3", url: validUrl),
            Card(title: "Card 4", distance: "Distance 4", url: validUrl)
        ]

        mockDataSource.cards = cards
        mockDataSource.load()

        XCTAssertEqual(view.subviews.count, 3)

        let expectation = XCTestExpectation()

        view.pan(sender: rightSwipe(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.view.subviews.count, 3)
            self.view.pan(sender: self.rightSwipe(card: self.view.subviews.last!))

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self.view.subviews.count, 2)
                XCTAssertEqual(self.view.subviews.last!.gestureRecognizers?.count, 1)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testEmptyOnceWeRunOutOfCards() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", url: validUrl)
        ]

        mockDataSource.cards = cards
        mockDataSource.load()

        let expectation = XCTestExpectation()

        view.pan(sender: rightSwipe(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.view.subviews.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCentersCardAgainIfGestureEndsWithoutDoingAnything() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", url: validUrl)
        ]

        mockDataSource.cards = cards
        mockDataSource.load()

        let expectation = XCTestExpectation()

        view.pan(sender: nonCommittalSwipe(card: view.subviews.last!))

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.view.subviews.first!.transform, .identity)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCardPanning() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", url: validUrl)
        ]

        mockDataSource.cards = cards
        mockDataSource.load()

        view.pan(sender: dragAndHold(card: view.subviews.last!))

        XCTAssertNotEqual(self.view.subviews.first!.transform, .identity)
    }

    func testMatchAccept() {
        let cards = [
            Card(title: "Gym 1", distance: "Distance 1", url: validUrl)
        ]

        mockDataSource.cards = cards
        mockDataSource.load()

        let topCard = view.subviews.last!

        view.pan(sender: rightSwipe(card: topCard))

        XCTAssertEqual(mockDelegate.lastChoice, .accept)
    }

    private func swipeLeft(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = -300
        gesture.state = .ended

        return gesture
    }

    private func rightSwipe(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = 300
        gesture.state = .ended

        return gesture
    }

    private func nonCommittalSwipe(card: UIView) -> UIPanGestureRecognizer {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = card
        gesture.xTranslation = 0
        gesture.state = .ended

        return gesture
    }

    private func dragAndHold(card: UIView) -> UIPanGestureRecognizer {
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
        case none
    }

    var lastChoice = Choice.none

    func accept() {
        lastChoice = .accept
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

private class MockCardDataSource: CardDataSource {
    var cards = [Card]()

    func next() -> Card? {
        cards.popLast()
    }

    func load() {
        cardPileView?.reload()
    }

    var cardPileView: CardPileView?
}
