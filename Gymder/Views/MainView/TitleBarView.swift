//
//  TitleBarView.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class TitleBarView: UIView {
    var titleLabel: UILabel!
    var bottomBorderView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel = UILabel()
        titleLabel.text = "gymder"
        titleLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        titleLabel.textColor = #colorLiteral(red: 0.993135035, green: 0.3929346204, blue: 0.4089930058, alpha: 1)
        titleLabel.textAlignment = .center

        bottomBorderView = UIView()
        bottomBorderView.backgroundColor = #colorLiteral(red: 0.8509055972, green: 0.851028502, blue: 0.8508786559, alpha: 1)

        addSubview(titleLabel)
        addSubview(bottomBorderView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
        bottomBorderView.frame = CGRect(x: 0, y: bounds.height - 1, width: bounds.width, height: 1)
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: titleLabel.intrinsicContentSize.width, height: titleLabel.intrinsicContentSize.height + 30)
    }
}
