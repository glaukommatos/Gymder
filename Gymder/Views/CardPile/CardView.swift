//
//  CardView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

/**

    This view lays out two `UILabel`s allowing them to take up as much space
    as they would like to. Then it fills up the remaining space with a `UIImage`.

 */

class CardView: UIView {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var distanceLabel: UILabel!

    var card: Card? {
        didSet {
            updateView(for: card)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        customizeViewAndLayerProperties()
        addImage()
        addTitleLabel()
        addDistanceLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        updateShadowPath()

        let insetBounds = bounds.insetBy(dx: 10, dy: 10)
        let interItemSpacing: CGFloat = 5

        titleLabel.preferredMaxLayoutWidth = insetBounds.width

        let intrinsicTitleHeight = titleLabel.intrinsicContentSize.height
        let intrinsicDistanceHeight = distanceLabel.intrinsicContentSize.height
        let remainingHeightForImage = insetBounds.height
                                        - intrinsicTitleHeight - intrinsicDistanceHeight
                                        - interItemSpacing * 2

        imageView.frame = CGRect(
            origin: CGPoint(x: insetBounds.origin.x, y: insetBounds.origin.y),
            size: CGSize(width: insetBounds.width, height: remainingHeightForImage)
        )

        titleLabel.frame = CGRect(
            origin: CGPoint(
                x: insetBounds.origin.x,
                y: insetBounds.origin.y + remainingHeightForImage + interItemSpacing
            ),
            size: CGSize(width: insetBounds.width, height: intrinsicTitleHeight)
        )

        distanceLabel.frame = CGRect(
            origin: CGPoint(
                x: insetBounds.origin.x,
                y: insetBounds.origin.y + intrinsicTitleHeight + remainingHeightForImage + interItemSpacing * 2
            ),
            size: CGSize(width: insetBounds.width, height: intrinsicDistanceHeight)
        )
    }

    private func customizeViewAndLayerProperties() {
        accessibilityIdentifier = "card"
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    private func addImage() {
        imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 2

        addSubview(imageView)
    }

    private func addTitleLabel() {
        titleLabel = UILabel()
        titleLabel.accessibilityIdentifier = "titleLabel"
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.allowsDefaultTighteningForTruncation = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)

        addSubview(titleLabel)
    }

    private func addDistanceLabel() {
        distanceLabel = UILabel()
        distanceLabel.accessibilityIdentifier = "distanceLabel"
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .body)

        addSubview(distanceLabel)
    }

    private func updateView(for card: Card?) {
        if let card = card {
            titleLabel.text = card.title
            distanceLabel.text = card.distance
            if let imageData = card.imageData {
                imageView.image = UIImage(data: imageData)
            }
        }
    }

    private func updateShadowPath() {
        let oldShadowPath = layer.shadowPath
        let newShadowPath = CGPath(rect: bounds, transform: nil)

        if let boundsAnimation = layer.animation(forKey: "bounds.size") as? CABasicAnimation {
            let shadowPathAnimation = CABasicAnimation(keyPath: "shadowPath")

            shadowPathAnimation.duration = boundsAnimation.duration
            shadowPathAnimation.timingFunction = boundsAnimation.timingFunction

            shadowPathAnimation.fromValue = oldShadowPath
            shadowPathAnimation.toValue = newShadowPath

            layer.add(shadowPathAnimation, forKey: "shadowPath")
        }

        layer.shadowPath = newShadowPath
    }
}
