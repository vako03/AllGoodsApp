//
//  AddAddressView.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 19.07.24.
//

import SwiftUI
import MapKit

struct AddAddressView: View {
    @Binding var addresses: [String]
    @State private var newAddress: String = ""
    @State private var title: String = ""
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var address: String = ""
    @State private var location: CLLocationCoordinate2D?
    @State private var showingAlert = false
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @StateObject private var searchViewModel = AddressSearchViewModel()
    @State private var searchText = ""

    var body: some View {
        VStack {
            TextField("Enter title (e.g., Home)", text: $title)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
            
            TextField("Search for address", text: $searchText, onCommit: {
                searchViewModel.search(query: searchText)
            })
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding()

            List(searchViewModel.searchResults, id: \.self) { item in
                VStack(alignment: .leading) {
                    Text(item.name ?? "No name")
                        .font(.headline)
                    Text(item.placemark.title ?? "No address")
                        .font(.subheadline)
                }
                .onTapGesture {
                    if let coordinate = item.placemark.location?.coordinate {
                        region.center = coordinate
                        fetchAddress(for: coordinate)
                        location = coordinate
                        searchText = ""
                        searchViewModel.searchResults = []
                    }
                }
            }
            
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: location == nil ? [] : [location!]) { loc in
                MapAnnotation(coordinate: loc) {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .imageScale(.large)
                }
            }
            .frame(height: 300)
            .onChange(of: region.center) { newCenter in
                fetchAddress(for: newCenter)
            }
            
            TextField("Address will appear here", text: $address)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                .disabled(true)

            Button(action: {
                if !title.isEmpty && location != nil {
                    let fullAddress = "\(title): \(address)"
                    addresses.append(fullAddress)
                    title = ""
                    address = ""
                    location = nil
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
            }
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text("Please enter a title and select a location on the map."), dismissButton: .default(Text("OK")))
            }

            Spacer()
        }
        .padding()
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
                self.location = location.coordinate
            } else {
                self.address = "Unable to determine address."
            }
        }
    }
}


import MapKit

extension CLLocationCoordinate2D: Identifiable {
    public var id: CLLocationDegrees {
        self.latitude + self.longitude
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
import Foundation
import MapKit
import Combine

class AddressSearchViewModel: ObservableObject {
    @Published var searchResults: [MKMapItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    func search(query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        
        let search = MKLocalSearch(request: request)
        search.start { [weak self] response, error in
            guard let self = self else { return }
            if let response = response {
                self.searchResults = response.mapItems
            } else if let error = error {
                print("Error searching for address: \(error.localizedDescription)")
                self.searchResults = []
            }
        }
    }
}
