//
//  RoundButton.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class RoundButton: UIButton {
    let height: CGFloat = 150
    var margin: CGFloat = 50

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        imageEdgeInsets = UIEdgeInsets(
            top: margin, left: margin, bottom: margin, right: margin
        )

        layer.cornerRadius = height / 2
        layer.borderWidth = 15
        layer.borderColor = #colorLiteral(red: 0.9646214843, green: 0.9647598863, blue: 0.9645913243, alpha: 1)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: height),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
