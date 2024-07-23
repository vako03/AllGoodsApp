//
//  GoogleMapView.swift
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

struct GoogleMapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var markers: [GMSMarker] = []
    var zoomLevel: Float = 15.0
    var isMyLocationEnabled: Bool = false

    func makeUIView(context: Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomLevel)
        let mapView = GMSMapView(frame: .zero, camera: camera)
        mapView.isMyLocationEnabled = isMyLocationEnabled
        mapView.settings.myLocationButton = isMyLocationEnabled
        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {
        uiView.clear()
        
        for marker in markers {
            marker.map = uiView
        }
        
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: zoomLevel)
        uiView.animate(to: camera)
        
        if isMyLocationEnabled {
            let userLocationView = MapAddressView().frame(width: 50, height: 50)
            let hostingController = UIHostingController(rootView: userLocationView)
            hostingController.view.backgroundColor = .clear
            hostingController.view.frame = CGRect(x: uiView.center.x - 25, y: uiView.center.y - 25, width: 50, height: 50)
            uiView.addSubview(hostingController.view)
        }
    }
}

struct MapAddressView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.5))
                .frame(width: 30, height: 30)
            Circle()
                .fill(Color.blue)
                .frame(width: 15, height: 15)
        }
    }
}
