//
//  CardPileView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class CardPileView: UIView {
    weak var cardChoiceDelegate: CardChoiceDelegate?
    weak var cardDataSource: CardDataSourceProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let loading = UIActivityIndicatorView(style: .gray)
        loading.startAnimating()
        loading.center = center

        addSubview(loading)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reload() {
        for view in subviews {
            view.removeFromSuperview()
        }

        for _ in 0..<3 {
            addNextCard()
        }
    }

    private var cardRect: CGRect {
        let cardWidth = bounds.width * 0.9
        let cardHeight = bounds.width + (cardWidth / 10)
        let xMargin = bounds.width - cardWidth
        let yMargin = bounds.height - cardHeight

        let origin = CGPoint(x: xMargin / 2, y: yMargin / 2)
        let size = CGSize(width: cardWidth, height: cardHeight)
        return CGRect(origin: origin, size: size)
    }

    private func positionCard(_ view: CardView) {
        let angleOfWiggle = CGFloat(radiansFrom: .random(in: -3..<3))
        view.transform = CGAffineTransform(rotationAngle: angleOfWiggle)
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
        if let card = cardDataSource?.next() {
            let nextCardView = CardView(frame: cardRect)
            nextCardView.card = card
            insertSubview(nextCardView, at: 0)
            positionCard(nextCardView)
        }

        addGestureRecognizerToTopmostCard()
    }

    private func addGestureRecognizerToTopmostCard() {
        if let topCard = subviews.last {
            let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan(sender:)))
            topCard.addGestureRecognizer(gestureRecognizer)
        }
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

                if translation.x > 0 {
                    cardChoiceDelegate?.accept()
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
}
