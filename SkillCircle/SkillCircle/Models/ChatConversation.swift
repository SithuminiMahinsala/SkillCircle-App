import Foundation

struct ChatConversation: Identifiable, Codable {
    let id: String
    let userName: String
    let userAvatar: String
    let subjectTag: String
    let lastMessage: String
    let timestamp: String
    var hasUnreadMessage: Bool
    let participantId: String
}