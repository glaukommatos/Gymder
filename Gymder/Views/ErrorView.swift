//
//  ErrorView.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import UIKit

class ErrorView: UIView {
    var retryHandler: (() -> Void)?
    private var stackView: UIStackView!

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black

        addStackView()
        addSadMacIcon()
        addMessage()
        addRetryButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func retry(sender: UIButton) {
        retryHandler?()
    }

    private func addStackView() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    private func addSadMacIcon() {
        let sadMac = UIImageView(image: UIImage(imageLiteralResourceName: "SadMac"))
        sadMac.contentMode = .center

        stackView.addArrangedSubview(sadMac)
    }

    private func addMessage() {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textColor = .white
        message.textAlignment = .center
        message.numberOfLines = 0
        message.text = "Fetching data failed.\nAre you sure you're online?"

        stackView.addArrangedSubview(message)
    }

    private func addRetryButton() {
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(retry(sender:)), for: .touchUpInside)
        retryButton.setTitleColor(.black, for: .normal)
        retryButton.backgroundColor = .white
        retryButton.layer.cornerRadius = 5

        stackView.addArrangedSubview(retryButton)
    }
}
