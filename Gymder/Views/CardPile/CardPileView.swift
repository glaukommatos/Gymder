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
    `UIPanGestureRecognizer` is added to each card
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

    let backFake = CardView()
    let frontFake = CardView()

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
        for _ in 0..<4 {
            addNextCard()
        }
    }

    var currentCards = 0
    private func updatePlaceholderVisibility() {
        DispatchQueue.main.async { [weak self] in
            switch self?.currentCards {
            case 2:
                UIView.animate(withDuration: 0.2) {
                    self?.backFake.alpha = 0
                    self?.frontFake.alpha = 1
                }
            case 1, 0:
                UIView.animate(withDuration: 0.2) {
                    self?.backFake.alpha = 0
                    self?.frontFake.alpha = 0
                }
            default:
                UIView.animate(withDuration: 0.2) {
                    self?.backFake.alpha = 1
                    self?.frontFake.alpha = 1
                }
            }
        }
    }

    private func addNextCard() {
        updatePlaceholderVisibility()

        cardDataSource?.next(completion: { [weak self] card in
            guard let card = card else { return }

            self?.currentCards += 1
            self?.updatePlaceholderVisibility()

            DispatchQueue.main.async {
                guard let self = self else { return }
                let nextCardView = CardView()
                nextCardView.card = card

                self.addGestureRecognizer(to: nextCardView)
                self.insertSubview(nextCardView, aboveSubview: self.frontFake)
            }
        })
    }

    private func addGestureRecognizer(to card: CardView) {
        let gestureRecognizer = UIPanGestureRecognizer(
            target: self, action: #selector(pan(sender:))
        )

        card.addGestureRecognizer(gestureRecognizer)
    }

    var panPercentage: CGFloat = 0.0
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let card = sender.view as? CardView,
              let cardIndex = subviews.firstIndex(of: card),
              cardIndex == subviews.count - 1 else { return }

        let translation = sender.translation(in: self)

        switch sender.state {
        case .began, .changed:
            card.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
            panPercentage = min(1.0, abs(translation.x) / 100.0)
        case .ended:
            panPercentage = 0
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
            self?.currentCards -= 1
            self?.updatePlaceholderVisibility()
            self?.addNextCard()
        }
    }

    private func returnCardToCenter(card: CardView) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: []) {
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
