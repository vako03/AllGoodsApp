//
//  CustomTextField.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

final class CustomTextField: UITextField {
    let rightIconButton: UIButton
    private let underline: UIView
    private var onIconTap: (() -> Void)?

    init(placeholder: String, isSecure: Bool = false, rightIconImage: UIImage?, onTextChange: ((String) -> Void)? = nil, onIconTap: (() -> Void)? = nil) {
        rightIconButton = UIButton(type: .custom)
        rightIconButton.setImage(rightIconImage, for: .normal)
        rightIconButton.tintColor = .black
        rightIconButton.isHidden = true

        underline = UIView()
        underline.backgroundColor = .black
        underline.translatesAutoresizingMaskIntoConstraints = false

        self.onIconTap = onIconTap

        super.init(frame: .zero)
        
        self.placeholder = placeholder
        self.isSecureTextEntry = isSecure
        self.borderStyle = .none
        self.translatesAutoresizingMaskIntoConstraints = false

        if let onTextChange = onTextChange {
            self.addAction(UIAction { action in
                onTextChange(self.text ?? "")
            }, for: .editingChanged)
        }

        if let onIconTap = onIconTap {
            rightIconButton.addAction(UIAction { action in
                onIconTap()
            }, for: .touchUpInside)
        }

        rightView = rightIconButton
        rightViewMode = .always
        
        addSubview(underline)
        
        NSLayoutConstraint.activate([
            underline.heightAnchor.constraint(equalToConstant: 1),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 8)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
