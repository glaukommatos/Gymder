//
//  CardView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

class CardView: UIView {
    var card: Card? {
        didSet {
            updateView(with: card)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        customizeViewAndLayerProperties()
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(distanceLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let insetBounds = bounds.insetBy(dx: 10, dy: 10)
        let interItemSpacing: CGFloat = 5

        titleLabel.preferredMaxLayoutWidth = insetBounds.width

        let intrinsicTitleHeight = titleLabel.intrinsicContentSize.height
        let intrinsicDistanceHeight = distanceLabel.intrinsicContentSize.height
        let remainingHeightForImage = insetBounds.height
                                        - intrinsicTitleHeight - intrinsicDistanceHeight
                                        - interItemSpacing * 2

        imageView.frame = CGRect(
            origin: CGPoint(x: bounds.origin.x, y: bounds.origin.y),
            size: CGSize(width: bounds.width, height: remainingHeightForImage + 10)
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

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.accessibilityIdentifier = "titleLabel"
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.allowsDefaultTighteningForTruncation = true
        titleLabel.minimumScaleFactor = 0.8
        titleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        titleLabel.textColor = #colorLiteral(red: 0.2391913533, green: 0.2392312586, blue: 0.2391825914, alpha: 1)
        return titleLabel
    }()

    lazy var distanceLabel: UILabel = {
        let distanceLabel = UILabel()
        distanceLabel.accessibilityIdentifier = "distanceLabel"
        distanceLabel.font = UIFont.preferredFont(forTextStyle: .body)
        distanceLabel.textColor = #colorLiteral(red: 0.2391913533, green: 0.2392312586, blue: 0.2391825914, alpha: 1)
        return distanceLabel
    }()

    private func customizeViewAndLayerProperties() {
        accessibilityIdentifier = "card"
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8509055972, green: 0.851028502, blue: 0.8508786559, alpha: 1)
    }

    private func updateView(with card: Card?) {
        if let card = card {
            titleLabel.text = card.title
            distanceLabel.text = card.distance
            if let imageData = card.imageData {
                imageView.image = UIImage(data: imageData)
            }
        }
    }
}
