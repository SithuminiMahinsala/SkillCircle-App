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
                    
                    let loaded: [ChatConversation] = documents.compactMap { doc in
                        let data = doc.data()
                        let id = doc.documentID
                        let participants = data["participants"] as? [String] ?? []
                        
                        guard participants.isEmpty || participants.contains(currentUserId) else { return nil }
                        
                        let userName = data["partnerName"] as? String ?? (data["userName"] as? String ?? "User")
                        let subjectName = data["subjectName"] as? String ?? "Subject"
                        let lastMessage = data["lastMessage"] as? String ?? ""
                        let timeString = data["timeString"] as? String ?? "Just now"
                        let unreadCount = data["unreadCount"] as? Int ?? 0
                        let isOnline = data["isOnline"] as? Bool ?? false
                        
                        return ChatConversation(
                            id: id,
                            userName: userName,
                            subjectName: subjectName,
                            lastMessage: lastMessage,
                            timeString: timeString,
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
                userName: "SHENALI MENON",
                subjectName: "STATISTICS",
                lastMessage: "Sure! I sent a session proposal for Tuesday.",
                timeString: "2:32 PM",
                unreadCount: 1,
                isOnline: true
            ),
            ChatConversation(
                id: "chat_2",
                userName: "KAVINDU PERERA",
                subjectName: "JAVA PROGRAMMING",
                lastMessage: "Let's review the object-oriented concepts tomorrow.",
                timeString: "Yesterday",
                unreadCount: 0,
                isOnline: false
            )
        ]
    }
}
