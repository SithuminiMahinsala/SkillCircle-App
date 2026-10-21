import SwiftUI
import MapKit

struct SessionLocationView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Sample session location data matching prototype
    let session: SessionLocationDetails = SessionLocationDetails(
        title: "Main University Library",
        subtitle: "2nd Floor, Quiet Study Zone,\nTable 12",
        subject: "Statistics",
        timeRange: "15:00 - 16:00",
        isActive: true,
        coordinate: CLLocationCoordinate2D(latitude: 6.9010, longitude: 79.8606) // Adjust for your campus
    )
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: 6.9010, longitude: 79.8606),
            distance: 400,
            pitch: 45
        )
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Map Canvas with Custom Annotation
            Map(position: $cameraPosition) {
                Annotation("", coordinate: session.coordinate) {
                    CustomMapPin()
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea(edges: .bottom)
            
            // 2. Floating Map Action Buttons (Top Right)
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Button(action: resetCamera) {
                            Image(systemName: "location.north.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "square.3.layers.3d.down.right")
                                .font(.body)
                                .bold()
                                .foregroundColor(.primary)
                                .padding(12)
                                .background(Color.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                        }
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 10)
                }
                Spacer()
            }
            
            // 3. Bottom Detail Card Overlay
            LocationDetailCard(session: session)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
        }
        .navigationTitle("SESSION LOCATION")
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
    
    private func resetCamera() {
        withAnimation(.easeInOut) {
            cameraPosition = .camera(
                MapCamera(centerCoordinate: session.coordinate, distance: 400, pitch: 45)
            )
        }
    }
}

// MARK: - Custom Map Pin
struct CustomMapPin: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.amberAccent, lineWidth: 3)
                .frame(width: 46, height: 46)
            
            Circle()
                .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                .frame(width: 36, height: 36)
            
            Image(systemName: "academiccap.fill")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
        }
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Location Detail Card Component
struct LocationDetailCard: View {
    let session: SessionLocationDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header: Location Title & Active Status Badge
            HStack(alignment: .top) {
                Text(session.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                    .lineLimit(2)
                
                Spacer()
                
                if session.isActive {
                    Text("ACTIVE")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(red: 0.88, green: 0.92, blue: 0.98))
                        .cornerRadius(12)
                }
            }
            
            // Subtitle Details
            Text(session.subtitle)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            // Meta Information Tags (Subject & Time)
            HStack(spacing: 12) {
                HStack(spacing: 6) {
                    Image(systemName: "chart.bar.fill")
                        .font(.caption)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    Text(session.subject)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color(red: 0.93, green: 0.96, blue: 1.0))
                .cornerRadius(10)
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(session.timeRange)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            .padding(.top, 2)
            
            // Directions Action Button
            Button(action: openMapsForDirections) {
                Text("Get Directions")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color(red: 0.22, green: 0.30, blue: 0.72))
                    .cornerRadius(26)
            }
            .padding(.top, 4)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.12), radius: 12, x: 0, y: 4)
    }
    
    // Opens Native Apple Maps for Turn-by-Turn Navigation
    private func openMapsForDirections() {
        let placemark = MKPlacemark(coordinate: session.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = session.title
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking
        ])
    }
}

// Color Accent Extension Helper
extension Color {
    static let amberAccent = Color(red: 0.95, green: 0.70, blue: 0.15)
}