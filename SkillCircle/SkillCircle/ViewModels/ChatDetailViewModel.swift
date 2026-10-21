import SwiftUI
import Combine

class ChatDetailViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var typedMessage: String = ""
    @Published var isTeacherView: Bool = false
    
    let partnerName: String
    let subjectName: String
    
    init(partnerName: String = "SHENALI", subjectName: String = "STATISTICS", isTeacherView: Bool = false) {
        self.partnerName = partnerName
        self.subjectName = subjectName
        self.isTeacherView = isTeacherView
        loadMessages()
    }
    
    func loadMessages() {
        self.messages = ChatDetailViewModel.mockMessages(isTeacher: isTeacherView)
    }
    
    func sendMessage() {
        guard !typedMessage.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            senderId: "CURRENT_USER",
            senderName: "Me",
            isFromCurrentUser: true,
            textMessage: typedMessage,
            proposal: nil,
            timestamp: "10:43 AM",
            dateHeader: nil
        )
        
        messages.append(newMessage)
        typedMessage = ""
        
        // TODO: Persist to Firebase Firestore collection("chats/{chatId}/messages")
    }
    
    func confirmProposal(proposalId: String) {
        if let index = messages.firstIndex(where: { $0.proposal?.id == proposalId }) {
            guard var proposal = messages[index].proposal else { return }
            proposal.status = .confirmed
            messages[index] = ChatMessage(
                id: messages[index].id,
                senderId: messages[index].senderId,
                senderName: messages[index].senderName,
                isFromCurrentUser: messages[index].isFromCurrentUser,
                textMessage: messages[index].textMessage,
                proposal: proposal,
                timestamp: messages[index].timestamp,
                dateHeader: messages[index].dateHeader
            )
        }
    }
    
    static func mockMessages(isTeacher: Bool) -> [ChatMessage] {
        return [
            ChatMessage(
                id: "MSG-01",
                senderId: "USER-LEARNER",
                senderName: "Shenali",
                isFromCurrentUser: !isTeacher,
                textMessage: "Hello! I'm struggling with the quadratic equations homework. Can we schedule a quick session today?",
                proposal: nil,
                timestamp: "10:42 AM",
                dateHeader: "TODAY, 31 MAR"
            ),
            ChatMessage(
                id: "MSG-02",
                senderId: "USER-TEACHER",
                senderName: "Me",
                isFromCurrentUser: isTeacher,
                textMessage: "Ok! i will send you proposal session. check and confirm it. if u have any changes inform me.",
                proposal: nil,
                timestamp: "10:42 AM",
                dateHeader: nil
            ),
            ChatMessage(
                id: "MSG-03",
                senderId: "USER-TEACHER",
                senderName: "Me",
                isFromCurrentUser: isTeacher,
                textMessage: nil,
                proposal: SessionProposal(
                    id: "PROP-01",
                    sessionId: isTeacher ? "SID-011" : "#ST-402",
                    dateText: "24 MAR 2026",
                    timeRange: "15 : 00 - 16 : 00",
                    location: "Library",
                    method: "Physical",
                    status: .awaitingConfirmation
                ),
                timestamp: "10:42 AM",
                dateHeader: nil
            )
        ]
    }
}