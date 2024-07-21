//
//  AddressInformationView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 19.07.24.
//

import SwiftUI
import MapKit
import Combine

struct AddressInformationView: View {
    @State private var addresses: [String] = []
    @State private var selectedAddress: String? = nil
    @State private var showingAddAddressView = false
    @State private var navigateToCheckout = false

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
                List {
                    ForEach(addresses, id: \.self) { address in
                        HStack {
                            Text(address)
                            Spacer()
                            Button(action: {
                                selectedAddress = address
                            }) {
                                Image(systemName: selectedAddress == address ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedAddress == address ? .green : .gray)
                            }
                        }
                    }
                }

                if selectedAddress != nil {
                    Button(action: {
                        navigateToCheckout = true
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
                    .background(
                        NavigationLink(
                            destination: CheckoutView(email: "test@example.com", phoneNumber: "+995 123 45 67 89", address: selectedAddress ?? ""),
                            isActive: $navigateToCheckout,
                            label: { EmptyView() }
                        )
                    )
                } else {
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
        }
        .sheet(isPresented: $showingAddAddressView) {
            AddAddressView(addresses: $addresses, selectedAddress: $selectedAddress)
        }
        .navigationTitle("Address Information")
    }
}