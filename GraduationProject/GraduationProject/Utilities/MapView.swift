//
//  MapView.swift
//  GraduationProject
//
//  Created by a mystic on 5/3/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    let place: String
    
    static private let latitude = LocationManager.manager.latitude
    static private let longitude = LocationManager.manager.longitude
    
    // test
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 36.628293, longitude: 127.456528), // 테스트 충북대 좌표
//        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)       // 반경
//    )
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), // 
        span: MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)       // 반경
    )
    
    @State private var parks: [ParkAnnotation] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: parks) { park in
                MapMarker(coordinate: park.coordinate, tint: .red)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                searchParksNearby()
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
    
    func searchParksNearby() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = place
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { (response, error) in
            guard let response = response else {
                if let error = error {
                    print("검색 오류: \(error.localizedDescription)")
                }
                return
            }
            parks = response.mapItems.map { ParkAnnotation(coordinate: $0.placemark.coordinate, name: $0.name) }
        }
    }
}

struct ParkAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String?
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(place: "운동장")
    }
}
