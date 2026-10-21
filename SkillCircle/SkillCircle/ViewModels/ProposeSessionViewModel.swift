import SwiftUI
import Combine
import MapKit

class ProposeSessionViewModel: ObservableObject {
    @Published var form: SessionProposalForm
    @Published var isSubmitting: Bool = false
    @Published var mapCameraPosition: MapCameraPosition
    
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
        
        // Simulated network delay / Firebase submission hook point
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
            guard let self = self else { return }
            self.isSubmitting = false
            
            // TODO: Connect with Firebase Firestore:
            // let db = Firestore.firestore()
            // db.collection("session_proposals").addDocument(data: [...])
            
            completion()
        }
    }
}