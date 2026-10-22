//
//  NotificationsViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

//
//  NotificationsViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var selectedTab: Int = 0 // 0 = All, 1 = Unread
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var filteredNotifications: [NotificationModel] {
        if selectedTab == 1 {
            return notifications.filter { !$0.isRead }
        }
        return notifications
    }
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchNotifications()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchNotifications() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        listenerRegistration = db.collection("notifications")
            .whereField("userId", isEqualTo: currentUserId)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.notifications = []
                        return
                    }
                    
                    self.notifications = documents.compactMap { doc -> NotificationModel? in
                        let data = doc.data()
                        let id = doc.documentID
                        let userId = data["userId"] as? String ?? ""
                        let title = data["title"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        let type = data["type"] as? String ?? "general"
                        let timestamp = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        let isRead = data["isRead"] as? Bool ?? false
                        
                        return NotificationModel(
                            id: id,
                            userId: userId,
                            title: title,
                            message: message,
                            type: type,
                            timestamp: timestamp,
                            isRead: isRead
                        )
                    }
                }
            }
    }
    
    func markAsRead(notificationId: String) {
        db.collection("notifications").document(notificationId).updateData([
            "isRead": true
        ])
    }
}
