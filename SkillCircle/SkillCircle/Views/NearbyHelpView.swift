//
//  NearbyHelpView.swift
//  SkillCircle
//

import SwiftUI
import MapKit

struct NearbyTutorPin: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let subject: String
    let coordinate: CLLocationCoordinate2D
    let rating: Double
    let isAvailable: Bool
    
    static func == (lhs: NearbyTutorPin, rhs: NearbyTutorPin) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct NearbyHelpView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612), // Campus/Local area center
            span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        )
    )
    
    @State private var selectedTutor: NearbyTutorPin? = nil
    
    let sampleTutors: [NearbyTutorPin] = [
        NearbyTutorPin(
            name: "SHENALI MENON",
            subject: "STATISTICS",
            coordinate: CLLocationCoordinate2D(latitude: 6.9285, longitude: 79.8625),
            rating: 4.9,
            isAvailable: true
        ),
        NearbyTutorPin(
            name: "KAVINDU PERERA",
            subject: "JAVA PROGRAMMING",
            coordinate: CLLocationCoordinate2D(latitude: 6.9255, longitude: 79.8595),
            rating: 4.8,
            isAvailable: true
        ),
        NearbyTutorPin(
            name: "NUVI SHENAYA",
            subject: "UI/UX DESIGN",
            coordinate: CLLocationCoordinate2D(latitude: 6.9298, longitude: 79.8640),
            rating: 5.0,
            isAvailable: false
        )
    ]
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Interactive Map
            Map(position: $cameraPosition, selection: $selectedTutor) {
                UserAnnotation()
                
                ForEach(sampleTutors) { tutor in
                    Annotation(tutor.name, coordinate: tutor.coordinate) {
                        Button(action: { selectedTutor = tutor }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 44, height: 44)
                                    .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                                
                                Image(systemName: "person.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(tutor.isAvailable ? Color(red: 0.22, green: 0.30, blue: 0.72) : .gray)
                            }
                        }
                    }
                    .tag(tutor)
                }
            }
            .mapControls {
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
            }
            
            // Selected Tutor Info Card Overlay
            if let tutor = selectedTutor {
                VStack(spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tutor.name)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            Text(tutor.subject)
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 14))
                            Text(String(format: "%.1f", tutor.rating))
                                .font(.system(size: 14, weight: .bold))
                        }
                    }
                    
                    Button(action: {
                        // Action to propose session or open chat with selected tutor
                    }) {
                        Text("Propose Session")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                            )
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.12), radius: 10, x: 0, y: 5)
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .animation(.spring(), value: selectedTutor?.id)
            }
        }
        .navigationTitle("NEARBY TUTORS")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NearbyHelpView()
    }
}
