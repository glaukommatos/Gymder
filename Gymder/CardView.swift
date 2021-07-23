//
//  View.swift
//  TestingTesting
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class CardView: UIView {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    var distanceLabel: UILabel!

    var card: Card? {
        didSet {
            guard let card = card else { return }
            titleLabel.text = card.title
            distanceLabel.text = card.distance
            DispatchQueue.global().async {
                guard let data = try? Data(contentsOf: card.url) else { return }
                let image = UIImage(data: data)

                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = image
                }
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addImage()
        addTitleLabel()
        addDistanceLabel()
        customizeAppearance()
    }

    private func customizeAppearance() {
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
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.backgroundColor = .darkGray
        imageView.contentMode = .scaleAspectFill

        addSubview(imageView)
    }

    private func addTitleLabel() {
        let remainingHeight = bounds.height - imageView.frame.height - 20
        let y = imageView.frame.height + 10

        titleLabel = UILabel(frame: CGRect(x: 10, y: y, width: bounds.width - 20, height: remainingHeight * (2/3)))
        titleLabel.font = UIFont.boldSystemFont(ofSize: remainingHeight * (2/3) - 5)

        addSubview(titleLabel)
    }

    private func addDistanceLabel() {
        let remainingHeight = bounds.height - imageView.frame.height - 20
        let y = imageView.frame.height + titleLabel.frame.height + 10

        distanceLabel = UILabel(frame: CGRect(x: 10, y: y, width: bounds.width - 20, height: remainingHeight * (1/3)))
        distanceLabel.font = UIFont.systemFont(ofSize: remainingHeight * (1/3) - 5, weight: .light)

        addSubview(distanceLabel)
    }

    required init(coder: NSCoder) { fatalError() }
}
