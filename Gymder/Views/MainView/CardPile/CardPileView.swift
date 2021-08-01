//
//  CardPileView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class CardPileView: UIView {
    enum SwipeDirection {
        case left
        case right
    }

    private static let animationDuration = 0.2
    private static let cardCount = 4

    weak var cardChoiceDelegate: CardPileChoiceDelegate?
    weak var cardDataSource: CardDataSourceProtocol?
    weak var cardPileReadinessDelegate: CardPileReadinessDelegate?

    private let backPlaceholderCard = CardView()
    private let frontPlaceholderCard = CardView()
    private var currentCardCount = 0
    private var busySwiping = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backPlaceholderCard)
        addSubview(frontPlaceholderCard)

        backPlaceholderCard.alpha = 0
        frontPlaceholderCard.alpha = 0
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

        backPlaceholderCard.bounds = bounds.insetBy(dx: 28, dy: 20)
        backPlaceholderCard.center = CGPoint(x: bounds.midX, y: bounds.midY + 8)

        frontPlaceholderCard.bounds = bounds.insetBy(dx: 24, dy: 20)
        frontPlaceholderCard.center = CGPoint(x: bounds.midX, y: bounds.midY + 4)
    }

    func load() {
        for _ in 0 ..< CardPileView.cardCount {
            addNextCard()
        }
    }

    func swipeTopCard(direction: SwipeDirection) {
        guard !busySwiping,
              let card = subviews.last as? CardView,
              card.alpha == 1 else { return }

        busySwiping = true

        UIView.animate(withDuration: CardPileView.animationDuration) { [weak self] in
            self?.moveOffscreen(view: card, inDirection: direction)
        } completion: { [weak self] _ in
            guard let self = self else { return }

            card.removeFromSuperview()

            self.currentCardCount -= 1
            self.busySwiping = false
            self.updateReadinessAndPlaceholderViews()
            self.updateCardChoiceDelegate(with: direction)
            self.addNextCard()
        }
    }

    private func updateCardChoiceDelegate(with direction: SwipeDirection) {
        switch direction {
        case .left:
            self.cardChoiceDelegate?.cardPile(self, didChoose: .reject)
        case .right:
            self.cardChoiceDelegate?.cardPile(self, didChoose: .accept)
        }
    }

    private func moveOffscreen(view: UIView, inDirection direction: SwipeDirection) {
        let translation: CGFloat
        switch direction {
        case .left:
            translation = -self.bounds.width * 2
        case .right:
            translation = self.bounds.width * 2
        }

        view.transform = CGAffineTransform(translationX: translation, y: 0)
    }

    private func updateReadinessAndPlaceholderViews() {
        cardPileReadinessDelegate?.cardPileView(self, didChangeReadiness: currentCardCount > 0)

        // I'm so sorry, I just REALLY wanted to have a stack of cards that would shrink
        // down to nothing as the cards run out. I decided always having a stack of
        // three looked nice (and like the Tinder screenshots).
        UIView.animate(withDuration: CardPileView.animationDuration) { [weak self] in
            guard let self = self else { return }
            switch self.currentCardCount {
            case 1, 0:
                self.backPlaceholderCard.alpha = 0
                self.frontPlaceholderCard.alpha = 0
            case 2:
                self.backPlaceholderCard.alpha = 0
                self.frontPlaceholderCard.alpha = 1
            case 3...CardPileView.cardCount:
                self.backPlaceholderCard.alpha = 1
                self.frontPlaceholderCard.alpha = 1
            default:
                assertionFailure("Big Nope: currentCardCount not in 0..<CardPileView.cardCount")
            }
        }
    }

    private func addNextCard() {
        cardDataSource?.next(completion: { [weak self] card in
            guard let self = self,
                  let card = card else { return }

            DispatchQueue.main.async {
                // Was really tempted to pretend I was implementing something like
                // `UITableView` and let the user register different views, for
                // reuse, but that's probably a little overkill. :)
                let nextCardView = CardView()
                nextCardView.card = card

                self.addGestureRecognizer(to: nextCardView)
                self.insertSubview(nextCardView, aboveSubview: self.frontPlaceholderCard)
                self.currentCardCount += 1
                self.updateReadinessAndPlaceholderViews()
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
}
