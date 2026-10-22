//
//  ProposeSessionViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import MapKit
import FirebaseFirestore
import FirebaseAuth

class ProposeSessionViewModel: ObservableObject {
    @Published var form: SessionProposalForm
    @Published var isSubmitting: Bool = false
    @Published var mapCameraPosition: MapCameraPosition
    @Published var alertMessage: String? = nil
    
    private let db = Firestore.firestore()
    
    init(subjectName: String = "STATISTICS") {
        var initialForm = SessionProposalForm()
        initialForm.subjectName = subjectName
        self.form = initialForm
        
        self.mapCameraPosition = .camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: initialForm.latitude,
                    longitude: initialForm.longitude
                ),
                distance: 500
            )
        )
    }
    
    func submitProposal(completion: @escaping () -> Void) {
        isSubmitting = true
        
        let currentUserId = Auth.auth().currentUser?.uid ?? "guest_user"
        
        let payload: [String: Any] = [
            "senderId": currentUserId,
            "goal": form.goal.rawValue,
            "subjectName": form.subjectName,
            "selectedDate": Timestamp(date: form.selectedDate),
            "startTime": Timestamp(date: form.startTime),
            "endTime": Timestamp(date: form.endTime),
            "method": form.method.rawValue,
            "physicalLocationType": form.physicalLocationType.rawValue,
            "building": form.building,
            "floor": form.floor,
            "room": form.room,
            "latitude": form.latitude,
            "longitude": form.longitude,
            "meetingLink": form.meetingLink,
            "estimatedTokens": form.estimatedTokens,
            "status": "PENDING",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        db.collection("session_proposals").addDocument(data: payload) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isSubmitting = false
                
                if let error = error {
                    self.alertMessage = "Failed to send proposal: \(error.localizedDescription)"
                } else {
                    print("Successfully saved proposal to Firestore!")
                    completion()
                }
            }
        }
    }
}
