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
                        // Navigate to the Check and Pay page
                        // Add your navigation logic here
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding()
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
