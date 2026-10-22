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
                        let text = data["textMessage"] as? String
                        let timestampDate = (data["timestamp"] as? Timestamp)?.dateValue() ?? Date()
                        let isFromCurrentUser = (senderId == currentUserId)
                        let senderName = isFromCurrentUser ? "Me" : self.partnerName
                        let timeString = self.formattedTimeString(from: timestampDate)
                        
                        var proposalObj: SessionProposal? = nil
                        if let pData = data["proposal"] as? [String: Any] {
                            let propId = pData["id"] as? String ?? id
                            let sessId = pData["sessionId"] as? String ?? ""
                            let dateText = pData["dateText"] as? String ?? ""
                            let timeRange = pData["timeRange"] as? String ?? ""
                            let location = pData["location"] as? String ?? ""
                            let method = pData["method"] as? String ?? ""
                            let rawStatus = pData["status"] as? String ?? "Awaiting for Confirmation"
                            let status = SessionProposal.ProposalStatus(rawValue: rawStatus) ?? .awaitingConfirmation
                            
                            proposalObj = SessionProposal(
                                id: propId,
                                sessionId: sessId,
                                dateText: dateText,
                                timeRange: timeRange,
                                location: location,
                                method: method,
                                status: status
                            )
                        }
                        
                        return ChatMessage(
                            id: id,
                            senderId: senderId,
                            senderName: senderName,
                            isFromCurrentUser: isFromCurrentUser,
                            textMessage: text,
                            proposal: proposalObj,
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
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("chats").document(chatId).collection("messages").getDocuments { [weak self] snapshot, _ in
            guard let self = self, let documents = snapshot?.documents else { return }
            
            for doc in documents {
                if var proposal = doc.data()["proposal"] as? [String: Any],
                   (proposal["id"] as? String) == proposalId {
                    
                    // 1. Update message proposal status
                    proposal["status"] = "Confirmed"
                    doc.reference.updateData(["proposal": proposal])
                    
                    let sessionId = proposal["sessionId"] as? String ?? proposalId
                    let dateText = proposal["dateText"] as? String ?? ""
                    let timeRange = proposal["timeRange"] as? String ?? ""
                    let location = proposal["location"] as? String ?? ""
                    let method = proposal["method"] as? String ?? "Physical"
                    
                    // 2. Fetch parent chat details to sync session participants
                    self.db.collection("chats").document(self.chatId).getDocument { chatDoc, _ in
                        let chatData = chatDoc?.data() ?? [:]
                        let participants = chatData["participants"] as? [String] ?? [currentUserId]
                        
                        let sessionRecord: [String: Any] = [
                            "id": sessionId,
                            "proposalId": proposalId,
                            "chatId": self.chatId,
                            "participants": participants,
                            "partnerName": self.partnerName,
                            "subjectName": self.subjectName,
                            "dateText": dateText,
                            "timeRange": timeRange,
                            "location": location,
                            "method": method,
                            "status": "Upcoming",
                            "updatedAt": FieldValue.serverTimestamp()
                        ]
                        
                        // 3. Upsert into top-level 'sessions' collection as 'Upcoming'
                        self.db.collection("sessions").document(sessionId).setData(sessionRecord, merge: true)
                    }
                }
            }
        }
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
