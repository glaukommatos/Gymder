//
//  CardPileView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

protocol CardPileReadinessDelegate: AnyObject {
    func ready(cardPileView: CardPileView, isReady: Bool)
}

class CardPileView: UIView {
    enum SwipeDirection {
        case left
        case right
    }

    static let animationDuration = 0.2
    static let cardCount = 4

    weak var cardChoiceDelegate: CardChoiceDelegate?
    weak var cardDataSource: CardDataSourceProtocol?
    weak var cardPileReadinessDelegate: CardPileReadinessDelegate?

    private let backFake = CardView()
    private let frontFake = CardView()
    private var currentCardCount = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backFake)
        addSubview(frontFake)

        backFake.alpha = 0
        frontFake.alpha = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        for subview in subviews {
            subview.bounds = bounds.insetBy(dx: 20, dy: 20)
            subview.center = CGPoint(x: bounds.midX, y: bounds.midY)
        }

        backFake.bounds = bounds.insetBy(dx: 28, dy: 20)
        backFake.center = CGPoint(x: bounds.midX, y: bounds.midY + 8)

        frontFake.bounds = bounds.insetBy(dx: 24, dy: 20)
        frontFake.center = CGPoint(x: bounds.midX, y: bounds.midY + 4)
    }

    func load() {
        for _ in 0 ..< CardPileView.cardCount {
            addNextCard()
        }
    }

    var busySwiping = false

    @discardableResult
    func swipeTopCard(direction: SwipeDirection) -> Bool {
        guard let card = subviews.last as? CardView,
              card.alpha == 1 else { return false }

        if busySwiping {
            return false
        }

        busySwiping = true

        let translation: CGFloat
        switch direction {
        case .left:
            translation = -500
        case .right:
            translation = 500
        }

        UIView.animate(withDuration: CardPileView.animationDuration) {
            card.transform = CGAffineTransform(
                translationX: translation, y: 0
            )
        } completion: { [weak self] _ in
            guard let self = self else { return }
            card.removeFromSuperview()
            self.currentCardCount -= 1
            self.busySwiping = false
            self.updatePlaceholderVisibility()
            self.addNextCard()

            switch direction {
            case .left:
                self.cardChoiceDelegate?.reject()
            case .right:
                self.cardChoiceDelegate?.accept()
            }
        }

        return true
    }

    private func updatePlaceholderVisibility() {
        let currentCardCount = self.currentCardCount
        cardPileReadinessDelegate?.ready(cardPileView: self, isReady: currentCardCount > 0)

        UIView.animate(withDuration: CardPileView.animationDuration) { [weak self] in
            guard let self = self else { return }

            switch currentCardCount {
            case 1, 0:
                self.backFake.alpha = 0
                self.frontFake.alpha = 0
            case 2:
                self.backFake.alpha = 0
                self.frontFake.alpha = 1
            case 3...CardPileView.cardCount:
                self.backFake.alpha = 1
                self.frontFake.alpha = 1
            default:
                preconditionFailure("Big Nope: currentCardCount not in 0..<CardPileView.cardCount")
            }
        }
    }

    private func addNextCard() {
        cardDataSource?.next(completion: { [weak self] card in
            guard let self = self,
                  let card = card else { return }
            DispatchQueue.main.async {
                let nextCardView = CardView()
                nextCardView.card = card

                self.addGestureRecognizer(to: nextCardView)
                self.insertSubview(nextCardView, aboveSubview: self.frontFake)
                self.currentCardCount += 1
                self.updatePlaceholderVisibility()
            }
        })
    }

    private func addGestureRecognizer(to card: CardView) {
        let gestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(pan(sender:))
        )

        card.addGestureRecognizer(gestureRecognizer)
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView,
              let cardIndex = subviews.firstIndex(of: card),
              cardIndex == subviews.count - 1 else { return }

        let translation = sender.translation(in: self)

        switch sender.state {
        case .began, .changed:
            card.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
            if abs(translation.x) > 100 {
                if translation.x > 0 {
                    swipeTopCard(direction: .right)
                } else {
                    swipeTopCard(direction: .left)
                }
            } else {
                returnCardToCenter(card: card)
            }
        default:
            return
        }
    }

    private func returnCardToCenter(card: CardView) {
        UIView.animate(withDuration: CardPileView.animationDuration) {
            card.transform = .identity
        }
    }

    private var cardSize: CGSize {
        let leastBound = min(bounds.height, bounds.width)
        let cardHeight = leastBound
        let cardWidth = cardHeight * (7/8)

        return CGSize(width: cardWidth, height: cardHeight)
    }
}
