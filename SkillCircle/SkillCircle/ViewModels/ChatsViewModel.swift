import SwiftUI
import Combine

class ChatsViewModel: ObservableObject {
    @Published var conversations: [ChatConversation] = []
    @Published var searchText: String = ""
    
    var filteredConversations: [ChatConversation] {
        if searchText.isEmpty {
            return conversations
        } else {
            return conversations.filter {
                $0.userName.localizedCaseInsensitiveContains(searchText) ||
                $0.subjectTag.localizedCaseInsensitiveContains(searchText) ||
                $0.lastMessage.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    init() {
        loadConversations()
    }
    
    func loadConversations() {
        self.conversations = ChatsViewModel.mockConversations
    }
    
    // MARK: - Firebase Listener (Future Swap)
    func listenToFirebaseChats(currentUserId: String) {
        // TODO: Swap mock data with real-time Firebase Firestore listener:
        // Firestore.firestore().collection("chats")
        //     .whereField("participants", arrayContains: currentUserId)
        //     .addSnapshotListener { snapshot, error in ... }
    }
    
    // MARK: - Mock Data
    static let mockConversations: [ChatConversation] = [
        ChatConversation(
            id: "CHAT-001",
            userName: "SETHMINA",
            userAvatar: "person.crop.circle.fill",
            subjectTag: "MATHEMATICS",
            lastMessage: "Session Proposal",
            timestamp: "10.30 AM",
            hasUnreadMessage: false,
            participantId: "USER-101"
        ),
        ChatConversation(
            id: "CHAT-002",
            userName: "SARAH",
            userAvatar: "person.crop.circle.fill",
            subjectTag: "UI/UX DESIGN",
            lastMessage: "Can You Review The UI?",
            timestamp: "10.30 AM",
            hasUnreadMessage: true,
            participantId: "USER-102"
        ),
        ChatConversation(
            id: "CHAT-003",
            userName: "NETH",
            userAvatar: "person.crop.circle.fill",
            subjectTag: "PHYSICS",
            lastMessage: "Thanks for the session!",
            timestamp: "Yesterday",
            hasUnreadMessage: false,
            participantId: "USER-103"
        ),
        ChatConversation(
            id: "CHAT-004",
            userName: "EMILY",
            userAvatar: "person.crop.circle.fill",
            subjectTag: "LITERATURE",
            lastMessage: "Where should we meet?",
            timestamp: "Monday",
            hasUnreadMessage: false,
            participantId: "USER-104"
        )
    ]
}