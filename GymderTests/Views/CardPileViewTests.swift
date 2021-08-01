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

    func testDisplaysAndMaintainsFourCardsAndTwoPlaceholdersWhilePossible() throws {
        let cards = [
            Card(title: "Card 1", distance: "Distance 1", imageData: nil),
            Card(title: "Card 2", distance: "Distance 2", imageData: nil),
            Card(title: "Card 3", distance: "Distance 3", imageData: nil),
            Card(title: "Card 4", distance: "Distance 4", imageData: nil),
            Card(title: "Card 5", distance: "Distance 5", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load()

        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            XCTAssertEqual(self?.visibleCardViews.count, 6)

            self?.rightSwipe()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self?.visibleCardViews.count, 6)

                self?.rightSwipe()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    XCTAssertEqual(self?.visibleCardViews.count, 5)
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
        view.load()

        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.swipeLeft()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self?.visibleCardViews.count, 0)
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
        view.load()

        let expectation = XCTestExpectation()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.nonCommittalSwipe()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
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
        view.load()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.dragAndHold()

            XCTAssertNotEqual(self?.topCard?.transform, .identity)
        }
    }

    func testMatchAccept() {
        let cards = [
            Card(title: "Gym 1", distance: "Distance 1", imageData: nil)
        ]

        mockDataSource.cards = cards
        view.load()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
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

    private var visibleCardViews: [CardView] {
        view.subviews.filter { cardView in
            guard let cardView = cardView as? CardView else { return false }
            return cardView.alpha != 0
        } as! [CardView]
    }

    private var topCard: CardView? {
        guard let topCard = visibleCardViews.last else {
            XCTFail("No Card Found")
            return nil
        }

        return topCard
    }
}
