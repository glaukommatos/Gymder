//
//  CardView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

// swiftlint:disable identifier_name

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

        customizeAppearance()
        addImage()
        addTitleLabel()
        addDistanceLabel()
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
        accessibilityIdentifier = "card"
        backgroundColor = .white
        layer.cornerRadius = 5
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.5
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    private func addImage() {
        let contentWidth = bounds.width - 20

        imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: contentWidth, height: contentWidth))

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
        let remainingHeight = bounds.height - imageView.frame.height - 20
        let y = imageView.frame.height + 10

        titleLabel = UILabel(frame: CGRect(x: 10, y: y, width: bounds.width - 20, height: remainingHeight * (2/3)))
        titleLabel.font = UIFont.boldSystemFont(ofSize: remainingHeight * (2/3) - 5)
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.1
        titleLabel.accessibilityIdentifier = "titleLabel"

        addSubview(titleLabel)
    }

    private func addDistanceLabel() {
        let remainingHeight = bounds.height - imageView.frame.height - 20
        let y = imageView.frame.height + titleLabel.frame.height + 10

        distanceLabel = UILabel(frame: CGRect(x: 10, y: y, width: bounds.width - 20, height: remainingHeight * (1/3)))
        distanceLabel.font = UIFont.systemFont(ofSize: remainingHeight * (1/3) - 5, weight: .light)
        distanceLabel.accessibilityIdentifier = "distanceLabel"

        addSubview(distanceLabel)
    }
}
