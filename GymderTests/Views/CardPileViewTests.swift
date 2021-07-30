//
//  CardPileViewTests.swift
//  GymderTests
//
//  Created by Kyle Pointer on 23.07.21.
//

// swiftlint:disable weak_delegate
// swiftlint:disable force_cast

import XCTest
@testable import Gymder

class CardPileViewTests: XCTestCase {
    private var view: CardPileView!
    private var mockDataSource: MockCardDataSource!
    private var mockDelegate: MockCardChoiceDelegate!

    override func setUp() {
        view = CardPileView()
        mockDelegate = MockCardChoiceDelegate()
        mockDataSource = MockCardDataSource()
        view.cardChoiceDelegate = mockDelegate
        view.cardDataSource = mockDataSource
    }

    func testDisplaysAndMaintainsThreeCardsWhilePossible() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", imageData: nil),
            Card(title: "Card 2", distance: "Distance 2", imageData: nil),
            Card(title: "Card 3", distance: "Distance 3", imageData: nil),
            Card(title: "Card 4", distance: "Distance 4", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load(count: 3)

        let expectation = XCTestExpectation()

        DispatchQueue.main.async { [weak self] in
            XCTAssertEqual(self?.cardViews.count, 3)

            self?.rightSwipe()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self?.cardViews.count, 3)

                self?.rightSwipe()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    XCTAssertEqual(self?.cardViews.count, 2)
                    XCTAssertEqual(self?.topCard?.gestureRecognizers?.count, 1)
                    expectation.fulfill()
                }
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testEmptyOnceOutOfCards() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load(count: 3)

        let expectation = XCTestExpectation()

        DispatchQueue.main.async { [weak self] in
            self?.swipeLeft()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self?.cardViews.count, 0)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCentersCardAgainIfGestureEndsWithoutDoingAnything() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load(count: 3)

        let expectation = XCTestExpectation()

        DispatchQueue.main.async { [weak self] in
            self?.nonCommittalSwipe()

            DispatchQueue.main.async {
                XCTAssertEqual(self?.topCard?.transform, .identity)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 5)
    }

    func testCardPanning() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load(count: 3)

        DispatchQueue.main.async { [weak self] in
            self?.dragAndHold()

            XCTAssertNotEqual(self?.topCard?.transform, .identity)
        }
    }

    func testMatchAccept() {
        let cards = [
            Card(title: "Gym 1", distance: "Distance 1", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load(count: 3)

        DispatchQueue.main.async { [weak self] in
            self?.rightSwipe()
            XCTAssertEqual(self?.mockDelegate.lastChoice, .accept)
        }
    }

    private func swipeLeft() {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = topCard
        gesture.xTranslation = -300
        gesture.state = .ended

        view.pan(sender: gesture)
    }

    private func rightSwipe() {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = topCard
        gesture.xTranslation = 300
        gesture.state = .ended

        view.pan(sender: gesture)
    }

    private func nonCommittalSwipe() {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = topCard
        gesture.xTranslation = 0
        gesture.state = .ended
        view.pan(sender: gesture)
    }

    private func dragAndHold() {
        let gesture = MockUIPanGestureRecognizer()
        gesture.theView = topCard
        gesture.xTranslation = 10
        gesture.state = .changed
        view.pan(sender: gesture)
    }

    private var cardViews: [CardView] {
        view.subviews.filter { $0 is CardView } as! [CardView]
    }

    private var topCard: CardView? {
        guard let topCard = cardViews.last else {
            XCTFail("No Card Found")
            return nil
        }

        return topCard
    }
}
