//
//  AddAddressView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 19.07.24.
//
import SwiftUI
import MapKit
import Combine
import GoogleMaps
import UIKit
import CoreLocation

struct AddAddressView: View {
    @Binding var addresses: [String]
    @Binding var selectedAddress: String?
    @State private var title: String = ""
    @State private var searchText: String = ""
    @State private var coordinate = CLLocationCoordinate2D(latitude: 41.7151, longitude: 44.8271)
    @State private var address: String = ""
    @State private var showingAlert = false
    @StateObject private var searchViewModel = AddressSearchViewModel()
    @StateObject private var locationManager = LocationManager()
    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search for address", text: $searchViewModel.searchQuery)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)

            List(searchViewModel.searchResults, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "No name")
                        .font(.headline)
                    Text(item.placemark.title ?? "No address")
                        .font(.subheadline)
                }
                .onTapGesture {
                    if let newCoordinate = item.placemark.location?.coordinate {
                        self.coordinate = newCoordinate
                        fetchAddress(for: newCoordinate)
                        searchViewModel.searchQuery = ""
                        searchViewModel.searchResults = []
                    }
                }
            }
            .frame(height: 100)

            GoogleMapView(coordinate: coordinate, isMyLocationEnabled: true)
                .frame(maxHeight: 350)
                .edgesIgnoringSafeArea(.bottom)

            Text("\(address)")
                .padding()
                .background(Color(.white))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom, 12)

            TextField("Enter title (e.g., Home)", text: $title)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.bottom, 12)

            Button(action: {
                if !title.isEmpty && !address.isEmpty {
                    let fullAddress = "\(title): \(address)"
                    addresses.append(fullAddress)
                    presentationMode.wrappedValue.dismiss()
                } else {
                    showingAlert = true
                }
            }) {
                Text("Save Address")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a title and select a location on the map."), dismissButton: .default(Text("OK")))
            }
            .padding(.bottom, 20)
        }
        .padding(.top)
        .onAppear {
            locationManager.requestLocation()
        }
        .onChange(of: locationManager.location) { newLocation in
            if let location = newLocation {
                self.coordinate = location.coordinate
                fetchAddress(for: location.coordinate)
            }
        }
    }

    private func fetchAddress(for location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.address = [
                    placemark.thoroughfare,
                    placemark.subThoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode
                ]
                .compactMap { $0 }
                .joined(separator: ", ")
            } else {
                self.address = "Unable to determine address."
            }
        }
    }
}
