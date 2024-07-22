//
//  CustomButton.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//
import UIKit

final class CustomButton: UIButton {
    init(title: String, action: @escaping () -> Void) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.backgroundColor = .black
        self.tintColor = .white
        self.layer.cornerRadius = 15
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true

        addAction(UIAction { _ in action() }, for: .touchUpInside)
        updateAppearance()
    }

    override var isEnabled: Bool {
        didSet {
            updateAppearance()
        }
    }

    private func updateAppearance() {
        self.alpha = isEnabled ? 1.0 : 0.5
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
