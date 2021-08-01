//
//  MainView.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class MainView: UIView {
    var titleBar: TitleBarView!
    var cardPileView: CardPileView!
    var choiceBar: ChoiceBarView!

    private var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)

        titleBar = TitleBarView()
        cardPileView = CardPileView()
        choiceBar = ChoiceBarView()

        stackView.addArrangedSubview(titleBar)
        stackView.addArrangedSubview(cardPileView)
        stackView.addArrangedSubview(choiceBar)
        stackView.sendSubviewToBack(choiceBar)

        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor),
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
