//
//  SessionsViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class SessionsViewModel: ObservableObject {
    @Published var selectedStatus: SessionStatus = .upcoming
    @Published var upcomingSessions: [TutoringSession] = []
    @Published var requestSessions: [TutoringSession] = []
    @Published var completedSessions: [TutoringSession] = []
    @Published var isLoading: Bool = false
    
    var filteredSessions: [TutoringSession] {
        switch selectedStatus {
        case .upcoming:
            return upcomingSessions
        case .requests:
            return requestSessions
        case .completed:
            return completedSessions
        }
    }
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchSessions()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchSessions() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        listenerRegistration?.remove()
        
        listenerRegistration = db.collection("sessions")
            .whereField("participants", arrayContains: currentUserId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                guard let documents = snapshot?.documents, error == nil else {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.upcomingSessions = []
                        self.requestSessions = []
                        self.completedSessions = []
                    }
                    return
                }
                
                var upcoming: [TutoringSession] = []
                var requests: [TutoringSession] = []
                var completed: [TutoringSession] = []
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEEE, MMM d"
                
                for doc in documents {
                    let data = doc.data()
                    let rawStatusString = data["status"] as? String ?? "Upcoming"
                    let statusEnum = self.parseSessionStatus(rawStatusString)
                    
                    let dateString = data["dateText"] as? String ?? data["date"] as? String ?? ""
                    let parsedDate = (data["createdAt"] as? Timestamp)?.dateValue() ?? dateFormatter.date(from: dateString) ?? Date()
                    
                    let item = TutoringSession(
                        id: doc.documentID,
                        subject: data["subjectName"] as? String ?? data["subject"] as? String ?? "GENERAL",
                        tutorName: data["partnerName"] as? String ?? data["tutorName"] as? String ?? "Tutor",
                        location: data["location"] as? String ?? "",
                        date: parsedDate,
                        status: statusEnum,
                        proposerId: data["proposerId"] as? String ?? "",
                        goal: data["goal"] as? String ?? "learning"
                    )
                    
                    switch item.status {
                    case .upcoming:
                        upcoming.append(item)
                    case .requests:
                        requests.append(item)
                    case .completed:
                        completed.append(item)
                    }
                }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.upcomingSessions = upcoming
                    self.requestSessions = requests
                    self.completedSessions = completed
                }
            }
    }
    
    private func parseSessionStatus(_ rawStatus: String) -> SessionStatus {
        if let status = SessionStatus(rawValue: rawStatus) {
            return status
        }
        let lower = rawStatus.lowercased()
        if lower.contains("await") || lower.contains("request") || lower.contains("pending") {
            return .requests
        } else if lower.contains("complete") {
            return .completed
        } else {
            return .upcoming
        }
    }
}
