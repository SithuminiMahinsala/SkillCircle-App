//
//  ChatDetailViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var typedMessage: String = ""
    @Published var isTeacherView: Bool = false
    
    let partnerName: String
    let subjectName: String
    let chatId: String
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init(partnerName: String = "SHENALI", subjectName: String = "STATISTICS", isTeacherView: Bool = false, chatId: String = "chat_1") {
        self.partnerName = partnerName
        self.subjectName = subjectName
        self.isTeacherView = isTeacherView
        self.chatId = chatId
        
        listenToMessages()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func listenToMessages() {
        listenerRegistration = db.collection("chats")
            .document(chatId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let documents = snapshot?.documents {
                    let currentUserId = Auth.auth().currentUser?.uid ?? ""
                    
                    let loadedMessages: [ChatMessage] = documents.compactMap { doc -> ChatMessage? in
                        let data = doc.data()
                        let id = doc.documentID
                        let senderId = data["senderId"] as? String ?? ""
                        let text = data["textMessage"] as? String ?? (data["text"] as? String ?? "")
                        let timestampDate = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        let isFromCurrentUser = (senderId == currentUserId)
                        let senderName = isFromCurrentUser ? "Me" : self.partnerName
                        let timeString = self.formattedTimeString(from: timestampDate)
                        
                        return ChatMessage(
                            id: id,
                            senderId: senderId,
                            senderName: senderName,
                            isFromCurrentUser: isFromCurrentUser,
                            textMessage: text,
                            proposal: nil,
                            timestamp: timeString,
                            dateHeader: nil
                        )
                    }
                    
                    DispatchQueue.main.async {
                        self.messages = loadedMessages
                    }
                }
            }
    }
    
    func sendMessage() {
        guard !typedMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let textToSend = typedMessage
        typedMessage = ""
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let messageData: [String: Any] = [
            "senderId": currentUserId,
            "textMessage": textToSend,
            "text": textToSend,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { [weak self] error in
            if error == nil {
                self?.db.collection("chats").document(self?.chatId ?? "").setData([
                    "lastMessage": textToSend,
                    "updatedAt": FieldValue.serverTimestamp()
                ], merge: true)
            }
        }
    }
    
    func confirmProposal(proposalId: String) {
        db.collection("session_proposals").document(proposalId).updateData([
            "status": "CONFIRMED"
        ])
    }
    
    func loadMessages() {
        listenToMessages()
    }
    
    private func formattedTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
