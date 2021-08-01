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
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "gymder"
        titleLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
        titleLabel.textColor = #colorLiteral(red: 0.993135035, green: 0.3929346204, blue: 0.4089930058, alpha: 1)
        titleLabel.textAlignment = .center
        titleLabel.sizeToFit()

        bottomBorderView = UIView()
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderView.backgroundColor = #colorLiteral(red: 0.8509055972, green: 0.851028502, blue: 0.8508786559, alpha: 1)

        addSubview(titleLabel)
        addSubview(bottomBorderView)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
            bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorderView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomBorderView.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
}
