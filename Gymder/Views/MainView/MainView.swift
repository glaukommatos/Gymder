//
//  MainView.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class MainView: UIView {
    lazy var titleBar = TitleBarView()
    lazy var cardPileView = CardPileView()
    lazy var choiceBar = ChoiceBarView()

    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addSubview(stackView)
        stackView.addArrangedSubview(titleBar)
        stackView.addArrangedSubview(cardPileView)
        stackView.addArrangedSubview(choiceBar)
        stackView.sendSubviewToBack(choiceBar)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
            choiceBar.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.2)
        ])
    }
}
