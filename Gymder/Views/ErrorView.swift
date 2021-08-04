//
//  ErrorView.swift
//  Gymder
//
//  Created by Kyle Pointer on 28.07.21.
//

import UIKit

class ErrorView: UIView {
    var closeHandler: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black

        addSubview(stackView)
        stackView.addArrangedSubview(sadMacIcon)
        stackView.addArrangedSubview(message)
        stackView.addArrangedSubview(retryButton)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var sadMacIcon: UIImageView = {
        let sadMac = UIImageView(image: UIImage(imageLiteralResourceName: "SadMac"))
        sadMac.contentMode = .center
        return sadMac
    }()

    private lazy var message: UILabel = {
        let message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.textColor = .white
        message.textAlignment = .center
        message.numberOfLines = 0
        message.text = "Fetching data failed.\nAre you sure you're online?"
        return message
    }()

    private lazy var retryButton: UIButton = {
        let retryButton = UIButton(type: .system)
        retryButton.setTitle("Retry", for: .normal)
        retryButton.addTarget(self, action: #selector(retry(sender:)), for: .touchUpInside)
        retryButton.setTitleColor(.black, for: .normal)
        retryButton.backgroundColor = .white
        retryButton.layer.cornerRadius = 5
        return retryButton
    }()

    func addConstraints() {
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    @objc func retry(sender: UIButton) {
        closeHandler?()
    }
}
