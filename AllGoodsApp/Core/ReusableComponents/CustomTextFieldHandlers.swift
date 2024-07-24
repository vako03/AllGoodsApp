//
//  CustomTextFieldHandlers.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 08.07.24.
//

import UIKit

final class CustomTextFieldHandlers {
    static func handleEmailTextChange(textField: CustomTextField, text: String) {
        textField.rightIconButton.isHidden = !isValidEmail(text)
    }

    static func handlePasswordTextChange(textField: CustomTextField, text: String) {
        textField.rightIconButton.isHidden = text.isEmpty
    }

    static func togglePasswordVisibility(textField: CustomTextField) {
        textField.isSecureTextEntry.toggle()
        let imageName = textField.isSecureTextEntry ? "eye.slash" : "eye"
        textField.rightIconButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
