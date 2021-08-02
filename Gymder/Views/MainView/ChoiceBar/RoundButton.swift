//
//  RoundButton.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class RoundButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        layer.borderWidth = 15
        layer.borderColor = #colorLiteral(red: 0.9646214843, green: 0.9647598863, blue: 0.9645913243, alpha: 1)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(lessThanOrEqualToConstant: 150),
            widthAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let height = bounds.height
        let margin = height / 3
        layer.cornerRadius = bounds.height / 2
        imageEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
