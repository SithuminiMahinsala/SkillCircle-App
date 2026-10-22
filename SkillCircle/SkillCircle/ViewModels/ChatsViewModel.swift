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
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        // Listen in real-time to conversations involving the current logged-in user
        listenerRegistration = db.collection("chats")
            .whereField("participants", arrayContains: currentUserId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else {
                        self.conversations = []
                        return
                    }
                    
                    self.conversations = documents.compactMap { doc -> ChatConversation? in
                        let data = doc.data()
                        let id = doc.documentID
                        let participants = data["participants"] as? [String] ?? []
                        
                        let participantId = participants.first(where: { $0 != currentUserId }) ?? "partner_id"
                        let userName = data["partnerName"] as? String ?? "User"
                        let userAvatar = data["userAvatar"] as? String ?? "person.circle.fill"
                        let subjectName = data["subjectName"] as? String ?? "GENERAL"
                        let lastMessage = data["lastMessage"] as? String ?? ""
                        
                        let timestampDate = (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
                        let formatter = DateFormatter()
                        formatter.timeStyle = .short
                        let timestamp = formatter.string(from: timestampDate)
                        
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
                }
            }
    }
    
    // Function to start or retrieve a real-time conversation between two users
    func createOrGetChat(with partnerUid: String, partnerName: String, subjectName: String, completion: @escaping (String) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let chatId = currentUserId < partnerUid ? "\(currentUserId)_\(partnerUid)" : "\(partnerUid)_\(currentUserId)"
        
        let chatRef = db.collection("chats").document(chatId)
        chatRef.getDocument { doc, error in
            if let doc = doc, doc.exists {
                completion(chatId)
            } else {
                let chatData: [String: Any] = [
                    "participants": [currentUserId, partnerUid],
                    "partnerName": partnerName,
                    "subjectName": subjectName,
                    "lastMessage": "Chat started",
                    "updatedAt": FieldValue.serverTimestamp()
                ]
                chatRef.setData(chatData) { _ in
                    completion(chatId)
                }
            }
        }
    }
}
