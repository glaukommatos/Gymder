//
//  MatchView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

class MatchView: UIView {
    private let balls = ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"]
    var closeHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addSubview(stackView)
        stackView.addArrangedSubview(message)
        stackView.addArrangedSubview(button)
        addSubview(ball1)
        addSubview(ball2)
        addConstraints()
        startAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30
        return stackView
    }()

    private lazy var message: UILabel = {
        let messageLabel = UILabel()
        messageLabel.text = "It's a match!"
        messageLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return messageLabel
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Awesome!", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemPink
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(executeCloseHandler), for: .touchUpInside)
        return button
    }()

    private lazy var ball1: UILabel = {
        let ball1 = UILabel()
        ball1.translatesAutoresizingMaskIntoConstraints = false
        ball1.text = balls.randomElement()
        ball1.alpha = 0.5
        ball1.baselineAdjustment = .alignCenters
        ball1.font = UIFont.systemFont(ofSize: 300)
        ball1.adjustsFontSizeToFitWidth = true
        return ball1
    }()

    private lazy var ball2: UILabel = {
        let ball2 = UILabel()
        ball2.translatesAutoresizingMaskIntoConstraints = false
        ball2.text = balls.randomElement()
        ball2.alpha = 0.5
        ball2.baselineAdjustment = .alignCenters
        ball2.font = UIFont.systemFont(ofSize: 300)
        ball2.adjustsFontSizeToFitWidth = true
        return ball2
    }()

    private func addConstraints() {
        NSLayoutConstraint.activate([
            ball1.topAnchor.constraint(equalTo: topAnchor, constant: -150),
            ball1.leftAnchor.constraint(equalTo: leftAnchor, constant: -150),
            ball2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 150),
            ball2.rightAnchor.constraint(equalTo: rightAnchor, constant: 150),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func startAnimation() {
        let animator = UIViewPropertyAnimator(
            duration: 1,
            curve: .linear,
            animations: { [weak self] in
                guard let self = self else { return }
                self.ball1.transform = self.ball1.transform.rotated(by: CGFloat.pi)
                self.ball2.transform = self.ball2.transform.rotated(by: CGFloat.pi)
            })

        animator.addCompletion { [weak self] _ in
            self?.startAnimation()
        }

        animator.startAnimation()
    }

    @objc func executeCloseHandler() {
        closeHandler?()
    }
}
