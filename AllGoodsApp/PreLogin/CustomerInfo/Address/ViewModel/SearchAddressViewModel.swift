//
//  SearchAddressViewModel.swift
//  AllGoodsApp
//
//  Created by valeri mekhashishvili on 24.07.24.
//

import Foundation
import SwiftUI
import MapKit
import Combine
import GoogleMaps
import UIKit
import CoreLocation

class AddressSearchViewModel: ObservableObject {
    @Published var searchResults: [MKMapItem] = []
    @Published var searchQuery: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.search(query: query)
            }
            .store(in: &cancellables)
    }

    private func search(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

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
