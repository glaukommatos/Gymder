//
//  MatchView.swift
//  Gymder
//
//  Created by Kyle Pointer on 23.07.21.
//

import UIKit

/**

    According to the instructions there needed to be some sort of
    matching _animation_. I'm not sure strictly speaking whether
    or not the animated modal presentation of a view controller
    really counts as this, so I figured I would at least use
    `UIViewPropertyAnimator` to spin some random balls
    around to try to keep things fun.

    Is this an abuse  of `UILabel`? Yeah, probably is.
    Is it worth it? Of course!

 */

class MatchView: UIView {
    private var animator: UIViewPropertyAnimator!
    private var ball1: UILabel!
    private var ball2: UILabel!

    private let balls = ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉"]

    var stackView: UIStackView!
    var closeHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        addStackView()
        addMessage()
        addButton()
        addBalls()
        addAndStartAnimations()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addStackView() {
        stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 30

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func addMessage() {
        let messageLabel = UILabel()
        messageLabel.text = "It's a match!"
        messageLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)

        stackView.addArrangedSubview(messageLabel)
    }

    private func addButton() {
        let button = UIButton(type: .system)
        button.setTitle("Awesome!", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(executeCloseHandler), for: .touchUpInside)

        stackView.addArrangedSubview(button)
    }

    private func addBalls() {
        ball1 = UILabel()
        ball1.translatesAutoresizingMaskIntoConstraints = false
        ball1.text = balls.randomElement()
        ball1.alpha = 0.5
        ball1.baselineAdjustment = .alignCenters
        ball1.font = UIFont.systemFont(ofSize: 300)
        ball1.adjustsFontSizeToFitWidth = true

        addSubview(ball1)

        ball2 = UILabel()
        ball2.translatesAutoresizingMaskIntoConstraints = false
        ball2.text = balls.randomElement()
        ball2.alpha = 0.5
        ball2.baselineAdjustment = .alignCenters
        ball2.font = UIFont.systemFont(ofSize: 300)
        ball2.adjustsFontSizeToFitWidth = true

        addSubview(ball2)

        NSLayoutConstraint.activate([
            ball1.topAnchor.constraint(equalTo: topAnchor, constant: -150),
            ball1.leftAnchor.constraint(equalTo: leftAnchor, constant: -150),
            ball2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 150),
            ball2.rightAnchor.constraint(equalTo: rightAnchor, constant: 150)
        ])
    }

    private func addAndStartAnimations() {
        animator = UIViewPropertyAnimator(duration: 1, curve: .linear, animations: { [weak self] in
            if let ball1 = self?.ball1,
               let ball2 = self?.ball2 {
                ball1.transform = ball1.transform.rotated(by: CGFloat.pi)
                ball2.transform = ball2.transform.rotated(by: CGFloat.pi)
            }
        })

        animator.addCompletion { [weak self] _ in
            self?.addAndStartAnimations()
        }

        animator.startAnimation()
    }

    @objc func executeCloseHandler() {
        closeHandler?()
    }
}
