//
//  CardPileView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

/**

    Pretty sure this is the longest file in the project. I hope it's not too bad.
    If there's any one file that's gonna show how little manual view layout
    I've done I suspect it's gonna be this one.

    Hopefully it's not too bad though. The idea here is to try to always
    maintain three `CardView`s as subviews until we exhaust the
    card data source.

    The cards are wiggled around a bit so that they look cute and a
    `UIPanGestureRecognizer` is added to the topmost card
    to allow the user to swipe left and right on the `CardView`s.

    Upon the initial load, there's also a little loading indicator, but
    this is removed as soon as cards `reload()` is called at
    which point will new `CardView`s will be created using
    `Card`s vended from the card data source.

    Hope it's not too unidiomatic as view code. Every time I open
    the docs for `UIView` I always learn something new, so I'm
    sure there's some room for improvement here.

 */

class CardPileView: UIView {
    weak var cardChoiceDelegate: CardChoiceDelegate?
    weak var cardDataSource: CardDataSourceProtocol?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white

        let loading = UIActivityIndicatorView(style: .gray)
        loading.startAnimating()

        addSubview(loading)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        for subview in subviews {
            subview.bounds = CGRect(origin: .zero, size: cardSize)
            subview.center = center
        }
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

    private func addNextCard() {
        if let card = cardDataSource?.next() {
            let nextCardView = CardView()
            nextCardView.card = card
            insertSubview(nextCardView, at: 0)
            positionCard(nextCardView)
        }

        addGestureRecognizerToTopmostCard()
    }

    private func positionCard(_ view: CardView) {
        let angleOfWiggle = CGFloat(radiansFrom: .random(in: -2..<2))
        view.transform = CGAffineTransform(rotationAngle: angleOfWiggle)
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

    private func removeSwipedCardAndAddAnother(_ card: CardView, _ translation: CGPoint) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) {
            card.transform = CGAffineTransform(translationX: translation.x * 5, y: translation.y)
        } completion: { [weak self] _ in
            card.removeFromSuperview()
            self?.addNextCard()
        }
    }

    private func returnCardToCenter(card: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) {
            card.transform = .identity
        }
    }

    private var cardSize: CGSize {
        let margin: CGFloat = bounds.height < bounds.width ? 20 : 0
        let leastBound = min(bounds.height, bounds.width)
        let cardHeight = leastBound - margin
        let cardWidth = cardHeight * (7/8)

        return CGSize(width: cardWidth, height: cardHeight)
    }
}
