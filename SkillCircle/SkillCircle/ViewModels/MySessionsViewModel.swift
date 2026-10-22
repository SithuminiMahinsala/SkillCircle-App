//
//  MySessionsViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class MySessionsViewModel: ObservableObject {
    @Published var selectedStatus: SessionStatus = .upcoming
    @Published var upcomingSessions: [TutoringSession] = []
    @Published var pastSessions: [TutoringSession] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var filteredSessions: [TutoringSession] {
        switch selectedStatus {
        case .completed:
            return pastSessions
        default:
            return upcomingSessions
        }
    }
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchUserSessions()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchUserSessions() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            loadMockSessions()
            return
        }
        
        isLoading = true
        
        listenerRegistration = db.collection("sessions")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    var upcoming: [TutoringSession] = []
                    var past: [TutoringSession] = []
                    
                    for doc in documents {
                        let data = doc.data()
                        let id = doc.documentID
                        let teacherId = data["teacherId"] as? String ?? ""
                        let learnerId = data["learnerId"] as? String ?? ""
                        
                        guard teacherId == currentUserId || learnerId == currentUserId else { continue }
                        
                        let subjectName = data["subjectName"] as? String ?? "Subject"
                        let partnerName = (teacherId == currentUserId) ? (data["learnerName"] as? String ?? "Learner") : (data["teacherName"] as? String ?? "Teacher")
                        let dateValue = (data["sessionDate"] as? Timestamp)?.dateValue() ?? Date()
                        let location = data["location"] as? String ?? "Campus Library"
                        let statusRaw = data["status"] as? String ?? "UPCOMING"
                        
                        let sessionStatus: SessionStatus = (statusRaw == "COMPLETED") ? .completed : .upcoming
                        
                        let sessionItem = TutoringSession(
                            id: id,
                            subject: subjectName,
                            tutorName: partnerName,
                            location: location,
                            date: dateValue,
                            status: sessionStatus
                        )
                        
                        if sessionStatus == .completed {
                            past.append(sessionItem)
                        } else {
                            upcoming.append(sessionItem)
                        }
                    }
                    
                    self.upcomingSessions = upcoming
                    self.pastSessions = past
                }
            }
    }
    
    private func loadMockSessions() {
        self.upcomingSessions = [
            TutoringSession(
                id: "s1",
                subject: "Statistics",
                tutorName: "NUVI SHENAYA",
                location: "Library",
                date: Date(),
                status: .upcoming
            )
        ]
        self.pastSessions = [
            TutoringSession(
                id: "s2",
                subject: "Java Programming",
                tutorName: "KAVINDU",
                location: "Online",
                date: Calendar.current.date(byAdding: .day, value: -10, to: Date()) ?? Date(),
                status: .completed
            )
        ]
        self.isLoading = false
    }
}
