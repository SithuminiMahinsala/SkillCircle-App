import Foundation

struct SessionProposal: Identifiable, Codable {
    let id: String
    let sessionId: String
    let dateText: String
    let timeRange: String
    let location: String
    let method: String
    var status: ProposalStatus
    
    enum ProposalStatus: String, Codable {
        case awaitingConfirmation = "Awaiting for Confirmation"
        case confirmed = "Confirmed"
        case declined = "Declined"
    }
}

struct ChatMessage: Identifiable, Codable {
    let id: String
    let senderId: String
    let senderName: String
    let isFromCurrentUser: Bool
    let textMessage: String?
    let proposal: SessionProposal?
    let timestamp: String
    let dateHeader: String?
}