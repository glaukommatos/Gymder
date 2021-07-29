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
        accessibilityIdentifier = "card"

        customizeAppearance()
        addImage()
        addTitleLabel()
        addDistanceLabel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let margins: CGFloat = 10
        let contentWidth = bounds.width - margins
        let contentHeight = bounds.height - margins
        let imageHeight = contentWidth - margins
        let remainingHeight = contentHeight - imageHeight - margins

        let imageY = margins
        let titleY = imageHeight + margins

        imageView.frame = CGRect(
            origin: CGPoint(x: margins, y: imageY),
            size: CGSize(width: imageHeight, height: imageHeight)
        )

        let titleHeight = remainingHeight * (2/3)
        let distanceHeight = remainingHeight * (1/3)

        titleLabel.frame = CGRect(
            origin: CGPoint(x: margins, y: titleY),
            size: CGSize(width: contentWidth - margins, height: titleHeight)
        )

        let distanceY = imageHeight + titleHeight + margins

        distanceLabel.frame = CGRect(
            origin: CGPoint(x: margins, y: distanceY),
            size: CGSize(width: contentWidth - margins, height: distanceHeight)
        )

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateView(for card: Card?) {
        if let card = card {
            titleLabel.text = card.title
            distanceLabel.text = card.distance
            fetchImage(url: card.url)
        }
    }

    private func customizeAppearance() {
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

    private func fetchImage(url: URL) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url) else { return }
            let image = UIImage(data: data)

            DispatchQueue.main.async { [weak self] in
                self?.imageView.image = image
            }
        }
    }

    private func addTitleLabel() {
        titleLabel = UILabel()
        titleLabel.accessibilityIdentifier = "titleLabel"
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 30)

        addSubview(titleLabel)
    }

    private func addDistanceLabel() {
        distanceLabel = UILabel()
        distanceLabel.accessibilityIdentifier = "distanceLabel"
        distanceLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)

        addSubview(distanceLabel)
    }
}
