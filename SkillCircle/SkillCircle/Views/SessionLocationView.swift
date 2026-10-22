//
//  SessionLocationView.swift
//  SkillCircle
//

import SwiftUI
import MapKit

struct SessionLocationView: View {
    @Environment(\.dismiss) private var dismiss
    var locationName: String
    var coordinate: CLLocationCoordinate2D
    
    @State private var cameraPosition: MapCameraPosition
    
    init(
        locationName: String = "Campus Library - Study Room 3",
        coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612)
    ) {
        self.locationName = locationName
        self.coordinate = coordinate
        _cameraPosition = State(initialValue: .region(
            MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        ))
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $cameraPosition) {
                Marker(locationName, coordinate: coordinate)
                    .tint(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            .ignoresSafeArea(edges: .bottom)
            
            VStack(spacing: 14) {
                HStack(spacing: 12) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("MEETING LOCATION")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                        Text(locationName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    }
                    Spacer()
                }
                
                Button(action: openInAppleMaps) {
                    HStack {
                        Image(systemName: "arrow.triangle.turn.up.right.diamond.fill")
                        Text("Get Directions in Apple Maps")
                    }
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                    )
                }
            }
            .padding(20)
            .background(Color.white)
            .cornerRadius(24)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -2)
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .navigationTitle("MEETING MAP")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
    }
    
    private func openInAppleMaps() {
        let placemark = MKPlacemark(coordinate: coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = locationName
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}

#Preview {
    NavigationStack {
        SessionLocationView()
    }
}
