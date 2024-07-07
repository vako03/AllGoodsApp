//
//  CustomLoader.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

final class CustomLoader: UIView {

    private let activityIndicator: UIActivityIndicatorView

    init(style: UIActivityIndicatorView.Style = .large) {
        self.activityIndicator = UIActivityIndicatorView(style: style)
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        layer.cornerRadius = 10
        clipsToBounds = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    func startLoading(in view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        activityIndicator.startAnimating()
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        removeFromSuperview()
    }
}

