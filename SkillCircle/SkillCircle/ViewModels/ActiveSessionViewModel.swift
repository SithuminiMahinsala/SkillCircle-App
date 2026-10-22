//
//  ActiveSessionViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class ActiveSessionViewModel: ObservableObject {
    @Published var activeSession: ActiveSession
    @Published var isSessionCompleted: Bool = false
    @Published var isVerifyingCode: Bool = false
    @Published var alertMessage: String? = nil
    
    // Convenience alias property for views expecting 'viewModel.session'
    var session: ActiveSession {
        get { activeSession }
        set { activeSession = newValue }
    }
    
    // Formats remaining time into MM:SS for the timer view
    var formattedTime: String {
        let minutes = activeSession.remainingSeconds / 60
        let seconds = activeSession.remainingSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private let db = Firestore.firestore()
    
    init(session: ActiveSession? = nil) {
        self.activeSession = session ?? ActiveSession(
            id: "sess_active_101",
            subjectName: "STATISTICS",
            learnerName: "SHENALI MENON",
            durationMinutes: 60,
            remainingSeconds: 3600,
            status: .active,
            qrCodePayload: "SKILL-STAT-2026"
        )
    }
    
    func verifyLearnerQRCode(scannedCode: String, completion: @escaping (Bool) -> Void) {
        isVerifyingCode = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            self.isVerifyingCode = false
            
            if scannedCode == self.activeSession.qrCodePayload || scannedCode.contains("SKILL") {
                self.completeSessionInFirestore(completion: completion)
            } else {
                self.alertMessage = "Invalid QR code scanned. Please try again."
                completion(false)
            }
        }
    }
    
    private func completeSessionInFirestore(completion: @escaping (Bool) -> Void) {
        let currentUserId = Auth.auth().currentUser?.uid ?? "teacher_id"
        let batch = db.batch()
        
        let sessionRef = db.collection("sessions").document(activeSession.id)
        batch.setData(["status": "COMPLETED", "completedAt": FieldValue.serverTimestamp()], forDocument: sessionRef, merge: true)
        
        let txRef = db.collection("users").document(currentUserId).collection("transactions").document()
        batch.setData([
            "title": "\(activeSession.subjectName) - Teaching",
            "subjectName": activeSession.subjectName,
            "amount": 1.0,
            "type": "EARNED",
            "dateString": "Today",
            "partnerName": activeSession.learnerName,
            "iconName": "star.fill",
            "timestamp": FieldValue.serverTimestamp()
        ], forDocument: txRef)
        
        batch.commit { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                if let error = error {
                    self.alertMessage = "Error updating session: \(error.localizedDescription)"
                    completion(false)
                } else {
                    self.isSessionCompleted = true
                    completion(true)
                }
            }
        }
    }
}
