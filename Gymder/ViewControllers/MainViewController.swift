//
//  MainViewController.swift
//  Gymder
//
//  Created by Kyle Pointer on 31.07.21.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
    var mainView: MainView!
    var cardPileViewController: CardPileViewController!
    var choiceBarViewController: ChoiceBarController!

    init(
        cardPileViewController: CardPileViewController,
        choiceBarViewController: ChoiceBarController
    ) {
        super.init(nibName: nil, bundle: nil)

        self.cardPileViewController = cardPileViewController
        self.choiceBarViewController = choiceBarViewController
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        mainView = MainView()
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainView.stackView.addArrangedSubview(TitleBar())
        mainView.stackView.addArrangedSubview(cardPileViewController.view)
        mainView.stackView.addArrangedSubview(choiceBarViewController.view)

        mainView.stackView.sendSubviewToBack(choiceBarViewController.view)

        addChild(cardPileViewController)
        addChild(choiceBarViewController)

        cardPileViewController.didMove(toParent: self)
        choiceBarViewController.didMove(toParent: self)
    }
}

class TitleBar: UIView {
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

class MainView: UIView {
    var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        addSubview(stackView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds.inset(by: safeAreaInsets)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
