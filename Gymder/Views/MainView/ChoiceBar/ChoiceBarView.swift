//
//  ChoiceBarView.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class ChoiceBarView: UIView {
    weak var delegate: ChoiceBarDelegate?

    var isEnabled: Bool {
        get {
            leftButton.isEnabled &&
                rightButton.isEnabled
        }
        set {
            leftButton.isEnabled = newValue
            rightButton.isEnabled = newValue
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(buttonContainer)
        buttonContainer.addSubview(leftButton)
        buttonContainer.addSubview(rightButton)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var buttonContainer: UIView = {
        let buttonContainer = UIView()
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        return buttonContainer
    }()

    private lazy var leftButton: RoundButton = {
        let leftButton = RoundButton(type: .system)
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        leftButton.setImage(UIImage(named: "Cross"), for: .normal)
        leftButton.tintColor = #colorLiteral(red: 0.9949885011, green: 0.4292141497, blue: 0.4242331982, alpha: 1)
        leftButton.accessibilityIdentifier = "swipeLeft"
        leftButton.addTarget(self, action: #selector(reject), for: .touchUpInside)
        return leftButton
    }()

    private lazy var rightButton: RoundButton = {
        let rightButton = RoundButton(type: .system)
        rightButton.setImage(UIImage(named: "Heart"), for: .normal)
        rightButton.tintColor = #colorLiteral(red: 0.3013241887, green: 0.7947661281, blue: 0.5758426189, alpha: 1)
        rightButton.accessibilityIdentifier = "swipeRight"
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.addTarget(self, action: #selector(accept), for: .touchUpInside)
        return rightButton
    }()

    private func addConstraints() {
        NSLayoutConstraint.activate([
            buttonContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonContainer.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            buttonContainer.heightAnchor.constraint(equalTo: leftButton.heightAnchor),
            buttonContainer.heightAnchor.constraint(equalTo: rightButton.heightAnchor),
            buttonContainer.centerYAnchor.constraint(equalTo: leftButton.centerYAnchor),
            buttonContainer.centerYAnchor.constraint(equalTo: rightButton.centerYAnchor),
            leftButton.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor),
            rightButton.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor),
            leftButton.rightAnchor.constraint(equalTo: rightButton.leftAnchor, constant: 15)
        ])
    }

    @objc func accept() {
        delegate?.choiceBar(self, didChoose: .accept)
    }

    @objc func reject() {
        delegate?.choiceBar(self, didChoose: .reject)
    }
}
