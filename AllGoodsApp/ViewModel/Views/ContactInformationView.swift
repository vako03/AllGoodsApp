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
                    .disabled(true) // Disabled to prevent editing
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Email*")
                    .font(.headline)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disabled(true) // Disabled to prevent editing
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Phone Number*")
                    .font(.headline)
                
                ZStack(alignment: .leading) {
                    if !isEditingPhoneNumber && phoneNumber == "+995 " {
                        Text("000 00 00")
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
            }
            .padding(.horizontal)
            
            Button(action: {
                // Handle continue action
            }) {
                Text("Continue")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    
    private func formatPhoneNumber() {
        if phoneNumber.hasPrefix("+995 ") {
            let formattedNumber = phoneNumber
                .replacingOccurrences(of: "+995 ", with: "")
                .replacingOccurrences(of: " ", with: "")
            var newString = "+995 "
            
            for (index, character) in formattedNumber.enumerated() {
                if index == 3 || index == 5 {
                    newString.append(" ")
                }
                newString.append(character)
            }
            
            if newString.count > 14 {
                newString = String(newString.prefix(14))
            }
            
            phoneNumber = newString
        } else {
            phoneNumber = "+995 "
        }
    }
}
