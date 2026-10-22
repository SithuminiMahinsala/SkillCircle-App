//
//  ChatsViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class ChatsViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var conversations: [ChatConversation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    // Filtered conversations based on search text input
    var filteredConversations: [ChatConversation] {
        if searchText.trimmingCharacters(in: .whitespaces).isEmpty {
            return conversations
        } else {
            return conversations.filter { conversation in
                conversation.userName.localizedCaseInsensitiveContains(searchText) ||
                conversation.subjectName.localizedCaseInsensitiveContains(searchText) ||
                conversation.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchChats()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchChats() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            loadMockConversations()
            return
        }
        
        isLoading = true
        
        listenerRegistration = db.collection("chats")
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents, !documents.isEmpty else {
                        self.loadMockConversations()
                        return
                    }
                    
                    let loaded: [ChatConversation] = documents.compactMap { doc -> ChatConversation? in
                        let data = doc.data()
                        let id = doc.documentID
                        let participants = data["participants"] as? [String] ?? []
                        
                        guard participants.isEmpty || participants.contains(currentUserId) else { return nil }
                        
                        let participantId = participants.first(where: { $0 != currentUserId }) ?? "partner_id"
                        let userName = data["partnerName"] as? String ?? (data["userName"] as? String ?? "User")
                        let userAvatar = data["userAvatar"] as? String ?? "person.circle.fill"
                        let subjectName = data["subjectName"] as? String ?? "STATISTICS"
                        let lastMessage = data["lastMessage"] as? String ?? ""
                        let timestamp = data["timeString"] as? String ?? (data["timestamp"] as? String ?? "Just now")
                        let unreadCount = data["unreadCount"] as? Int ?? 0
                        let hasUnread = unreadCount > 0 || (data["hasUnreadMessage"] as? Bool ?? false)
                        let isOnline = data["isOnline"] as? Bool ?? false
                        
                        return ChatConversation(
                            id: id,
                            participantId: participantId,
                            userName: userName,
                            userAvatar: userAvatar,
                            subjectName: subjectName,
                            lastMessage: lastMessage,
                            timestamp: timestamp,
                            hasUnreadMessage: hasUnread,
                            unreadCount: unreadCount,
                            isOnline: isOnline
                        )
                    }
                    
                    self.conversations = loaded.isEmpty ? self.getMockList() : loaded
                }
            }
    }
    
    private func loadMockConversations() {
        self.conversations = getMockList()
        self.isLoading = false
    }
    
    private func getMockList() -> [ChatConversation] {
        return [
            ChatConversation(
                id: "chat_1",
                participantId: "p1",
                userName: "SHENALI MENON",
                userAvatar: "person.circle.fill",
                subjectName: "STATISTICS",
                lastMessage: "Sure! I sent a session proposal for Tuesday.",
                timestamp: "2:32 PM",
                hasUnreadMessage: true,
                unreadCount: 1,
                isOnline: true
            ),
            ChatConversation(
                id: "chat_2",
                participantId: "p2",
                userName: "KAVINDU PERERA",
                userAvatar: "person.circle.fill",
                subjectName: "JAVA PROGRAMMING",
                lastMessage: "Let's review the object-oriented concepts tomorrow.",
                timestamp: "Yesterday",
                hasUnreadMessage: false,
                unreadCount: 0,
                isOnline: false
            )
        ]
    }
}
