//
//  CardView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit
import CoreLocation

/**

    Might not be the prettiest view, but is sure knows how to draw
    rectangular regions on the screen.

    I'm not super sold on this lazy-image-loading thing I''m doing
    in here for a few reasons. I think I'd rather do this somewhere
    else and not display the `CardView` at all until it actually has
    its image data fetched.

    But that's a change I'll have to make later. :)

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

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath

        let insetMargin: CGFloat = 10
        let interItemSpacing: CGFloat = 5

        titleLabel.preferredMaxLayoutWidth = bounds.width - insetMargin * 2

        let intrinsicTitleHeight = titleLabel.intrinsicContentSize.height
        let intrinsicDistanceHeight = distanceLabel.intrinsicContentSize.height
        let remainingHeightForImage = bounds.height
                                        - intrinsicTitleHeight - intrinsicDistanceHeight
                                        - interItemSpacing * 2 - insetMargin * 2

        imageView.frame = CGRect(
            origin: CGPoint(x: insetMargin, y: insetMargin),
            size: CGSize(width: bounds.width - insetMargin * 2, height: remainingHeightForImage)
        )

        titleLabel.frame = CGRect(
            origin: CGPoint(x: insetMargin, y: remainingHeightForImage + insetMargin + interItemSpacing),
            size: CGSize(width: bounds.width - insetMargin * 2, height: intrinsicTitleHeight)
        )

        distanceLabel.frame = CGRect(
            origin: CGPoint(
                x: insetMargin,
                y: intrinsicTitleHeight + remainingHeightForImage + insetMargin + interItemSpacing * 2
            ),
            size: CGSize(width: bounds.width - insetMargin * 2, height: intrinsicDistanceHeight)
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
            fetchImage(url: card.url)
        }
    }

    private func fetchImage(url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)

            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }
}
