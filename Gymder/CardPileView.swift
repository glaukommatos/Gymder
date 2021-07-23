//
//  CardPileView.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class CardPileView: UIView {
    weak var cardChoiceDelegate: CardChoiceDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 0.9180306636, blue: 0.8244608181, alpha: 1)
    }

    required init?(coder: NSCoder) { fatalError() }

    private var remainingCards = [Card]()
    var cards: [Card] {
        set {
            remainingCards = newValue
            updateCardViews()
        }
        get { remainingCards }
    }

    private func updateCardViews() {
        for view in subviews {
            view.removeFromSuperview()
        }

        for _ in 0...2 {
            if let card = remainingCards.popLast() {
                let view = CardView(frame: calculateCardRect())
                view.card = card
                insertSubview(view, at: 0)
                positionCard(view)
            }
        }

        setupPanGesture()
    }

    private func setupPanGesture() {
        if let topCard = subviews.last {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
            topCard.addGestureRecognizer(gestureRecognizer)
        }
    }

    private func calculateCardRect() -> CGRect {
        let cardWidth = bounds.width * 0.9
        let cardHeight = bounds.width + (cardWidth / 10)
        let xMargin = bounds.width - cardWidth
        let yMargin = bounds.height - cardHeight

        let origin = CGPoint(x: xMargin / 2, y: yMargin / 2)
        let size = CGSize(width: cardWidth, height: cardHeight)
        return CGRect(origin: origin, size: size)
    }

    private func positionCard(_ view: CardView) {
        view.transform = CGAffineTransform(rotationAngle: radians(from: CGFloat.random(in: -3..<3)))
    }

    private func removeSwipedCardAndAddAnother(_ card: CardView, _ translation: CGPoint) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) {
            card.transform = CGAffineTransform(translationX: translation.x * 5, y: translation.y)
        } completion: { [weak self] _ in
            card.removeFromSuperview()
            self?.addNextCard()
        }
    }

    private func addNextCard() {
        if let nextCard = remainingCards.popLast() {
            let nextCardView = CardView(frame: calculateCardRect())
            nextCardView.card = nextCard
            insertSubview(nextCardView, at: 0)
            positionCard(nextCardView)
        }

        setupPanGesture()
    }

    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView else { return }
        let translation = sender.translation(in: self)

        switch sender.state {
        case .began, .changed:
            card.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        case .ended:
            if abs(translation.x) > 100 {
                removeSwipedCardAndAddAnother(card, translation)

                if (translation.x > 0) {
                    cardChoiceDelegate?.accept()
                } else {
                    cardChoiceDelegate?.reject()
                }
            } else {
                returnCardToCenter(card: card)
            }
        default:
            return
        }
    }

    private func returnCardToCenter(card: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) {
            card.transform = .identity
        }
    }

    private func radians(from degrees: CGFloat) -> CGFloat {
        degrees * (CGFloat.pi / 180)
    }
}

protocol CardChoiceDelegate: AnyObject {
    func accept()
    func reject()
}
