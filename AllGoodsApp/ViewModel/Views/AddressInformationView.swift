//
//  AddressInformationView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 19.07.24.
//

import SwiftUI

struct AddressInformationView: View {
    @State private var addresses: [String] = [] // Replace with your actual address model
    @State private var showingAddAddressView = false

    var body: some View {
        VStack {
            if addresses.isEmpty {
                Text("No addresses yet")
                    .font(.headline)
                    .padding()

                Button(action: {
                    showingAddAddressView.toggle()
                }) {
                    Text("Add New Address")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            } else {
                List(addresses, id: \.self) { address in
                    Text(address) // Display your actual address details
                }

                Button(action: {
                    showingAddAddressView.toggle()
                }) {
                    Text("Add New Address")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .sheet(isPresented: $showingAddAddressView) {
            AddAddressView(addresses: $addresses)
        }
        .navigationTitle("Address Information")
    }
}

