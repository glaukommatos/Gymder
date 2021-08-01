//
//  MainView.swift
//  Gymder
//
//  Created by Kyle Pointer on 01.08.21.
//

import UIKit

class MainView: UIView {
    var titleBar: TitleBar!
    var cardPileView: CardPileView!
    var choiceBar: ChoiceBar!

    private var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)

        titleBar = TitleBar()
        cardPileView = CardPileView()
        choiceBar = ChoiceBar()

        stackView.addArrangedSubview(titleBar)
        stackView.addArrangedSubview(cardPileView)
        stackView.addArrangedSubview(choiceBar)
        stackView.sendSubviewToBack(choiceBar)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: safeAreaInsets)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}