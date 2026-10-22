//
//  SessionDetailViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//



//
//  SessionDetailViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore

class SessionDetailViewModel: ObservableObject {
    @Published var session: SessionDetailModel
    @Published var isLoading: Bool = false
    @Published var showCancelAlert: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    
    init(session: SessionDetailModel? = nil) {
        self.session = session ?? SessionDetailModel(
            id: "sess_101",
            subjectName: "STATISTICS",
            status: .confirmed,
            teacherName: "NUVI SHENAYA",
            teacherAvatarUrl: "TutorNuvi",
            learnerName: "SHENALI MENON",
            learnerAvatarUrl: "TutorShenali",
            dateString: "24 MAR 2026",
            timeString: "15 : 00 - 16 : 00",
            locationName: "Library"
        )
        
        if let sessionId = session?.id, sessionId != "sess_101" {
            fetchSessionFromFirestore(sessionId: sessionId)
        }
    }
    
    func fetchSessionFromFirestore(sessionId: String) {
        isLoading = true
        db.collection("sessions").document(sessionId).getDocument { [weak self] snapshot, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let data = snapshot?.data() {
                    let subjectName = data["subjectName"] as? String ?? "STATISTICS"
                    let statusRaw = data["status"] as? String ?? "CONFIRMED"
                    let status: SessionDetailStatus = (statusRaw == "CANCELLED") ? .cancelled : .confirmed
                    let teacherName = data["teacherName"] as? String ?? "NUVI SHENAYA"
                    let learnerName = data["learnerName"] as? String ?? "SHENALI MENON"
                    let dateString = data["dateString"] as? String ?? "24 MAR 2026"
                    let timeString = data["timeString"] as? String ?? "15:00 - 16:00"
                    let locationName = data["locationName"] as? String ?? "Library"
                    
                    self.session = SessionDetailModel(
                        id: sessionId,
                        subjectName: subjectName,
                        status: status,
                        teacherName: teacherName,
                        teacherAvatarUrl: "TutorNuvi",
                        learnerName: learnerName,
                        learnerAvatarUrl: "TutorShenali",
                        dateString: dateString,
                        timeString: timeString,
                        locationName: locationName
                    )
                }
            }
        }
    }
    
    func cancelSession(completion: @escaping () -> Void) {
        isLoading = true
        
        db.collection("sessions").document(session.id).updateData([
            "status": "CANCELLED",
            "updatedAt": FieldValue.serverTimestamp()
        ]) { [weak self] error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                if error == nil {
                    self.session = SessionDetailModel(
                        id: self.session.id,
                        subjectName: self.session.subjectName,
                        status: .cancelled,
                        teacherName: self.session.teacherName,
                        teacherAvatarUrl: self.session.teacherAvatarUrl,
                        learnerName: self.session.learnerName,
                        learnerAvatarUrl: self.session.learnerAvatarUrl,
                        dateString: self.session.dateString,
                        timeString: self.session.timeString,
                        locationName: self.session.locationName
                    )
                    completion()
                }
            }
        }
    }
}
