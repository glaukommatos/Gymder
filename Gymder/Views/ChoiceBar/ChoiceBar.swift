//
//  ChoiceBar.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class ChoiceBar: UIView {
    var buttonContainer: ButtonContainer!
    weak var delegate: ChoiceBarDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        buttonContainer = ButtonContainer()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.choiceBar = self

        addSubview(buttonContainer)

        NSLayoutConstraint.activate([
            buttonContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func accept() {
        delegate?.accept(choiceBar: self)
    }

    func reject() {
        delegate?.reject(choiceBar: self)
    }
}

class ButtonContainer: UIView {
    var leftButton: RoundButton!
    var rightButton: RoundButton!

    weak var choiceBar: ChoiceBar?

    override init(frame: CGRect) {
        super.init(frame: frame)

        leftButton = RoundButton(type: .system)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(UIImage(named: "Cross"), for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9949885011, green: 0.4292141497, blue: 0.4242331982, alpha: 1)
        leftButton.accessibilityIdentifier = "swipeLeft"
        leftButton.addTarget(self, action: #selector(reject), for: .touchUpInside)

        rightButton = RoundButton(type: .system)
        rightButton.setImage(UIImage(named: "Heart"), for: .normal)
        rightButton.tintColor = #colorLiteral(red: 0.3013241887, green: 0.7947661281, blue: 0.5758426189, alpha: 1)
        rightButton.accessibilityIdentifier = "swipeRight"
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addTarget(self, action: #selector(accept), for: .touchUpInside)

        addSubview(leftButton)
        addSubview(rightButton)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalTo: leftButton.heightAnchor),
            heightAnchor.constraint(equalTo: rightButton.heightAnchor),
            centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            centerYAnchor.constraint(equalTo: rightButton.centerYAnchor),
            leftButton.leftAnchor.constraint(equalTo: leftAnchor),
            rightButton.rightAnchor.constraint(equalTo: rightAnchor),
            leftButton.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: 15)
        ])
    }

    @objc func accept() {
        choiceBar?.accept()
    }

    @objc func reject() {
        choiceBar?.reject()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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

    override var intrinsicContentSize: CGSize {
        CGSize(width: height, height: height)
    }
}
