//
//  ContactInformationView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 19.07.24.
//
import SwiftUI

struct ContactInformationView: View {
    @State var nickname: String
    @State var email: String
    @State var phoneNumber: String = "+995 "
    @State private var isEditingPhoneNumber = false
    @State private var showingAddressInformationView = false
    @State private var phoneNumberErrorMessage: String?
    var cartProducts: [CartProduct]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Contact Information")
                .font(.largeTitle)
                .padding()

            VStack(alignment: .leading, spacing: 8) {
                Text("Nickname*")
                    .font(.headline)

                TextField("Nickname", text: $nickname)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disabled(true)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Email*")
                    .font(.headline)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disabled(true)
            }
            .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number*")
                    .font(.headline)

                ZStack(alignment: .leading) {
                    if !isEditingPhoneNumber && phoneNumber == "+995 " {
                        Text("000 00 00 00")
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    }

                    TextField("", text: $phoneNumber, onEditingChanged: { isEditing in
                        isEditingPhoneNumber = isEditing
                    })
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                    .onChange(of: phoneNumber) { newValue in
                        formatPhoneNumber()
                    }
                }

                if let errorMessage = phoneNumberErrorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal)

            NavigationLink(destination: AddressInformationView(email: email, phoneNumber: phoneNumber, cartProducts: cartProducts), isActive: $showingAddressInformationView) {
                Button(action: {
                    if isValidPhoneNumber() {
                        showingAddressInformationView.toggle()
                    }
                }) {
                    Text("Continue")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
    }

    private func formatPhoneNumber() {
        var cleanedNumber = phoneNumber
            .replacingOccurrences(of: "+995 ", with: "")
            .replacingOccurrences(of: " ", with: "")

        if cleanedNumber.count > 9 {
            cleanedNumber = String(cleanedNumber.prefix(9))
        }

        var newString = "+995 "

        for (index, character) in cleanedNumber.enumerated() {
            if index == 3 || index == 5 || index == 7 || index == 9 {
                newString.append(" ")
            }
            newString.append(character)
        }

        phoneNumber = newString
    }

    private func isValidPhoneNumber() -> Bool {
        let phoneNumberWithoutSpaces = phoneNumber.replacingOccurrences(of: " ", with: "")
        if phoneNumberWithoutSpaces.count != 13 { // +995 + 9 digits = 13
            phoneNumberErrorMessage = "Phone number must be in the format +995 000 00 00 00"
            return false
        }
        phoneNumberErrorMessage = nil
        return true
    }
}
