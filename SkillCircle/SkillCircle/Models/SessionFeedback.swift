import Foundation

struct CompletedSessionSummary {
    let sessionId: String
    let subjectName: String
    let teacherName: String
    let durationMinutes: Int
    let tokensEarned: Double
}

struct SessionFeedback: Codable {
    let id: String
    let sessionId: String
    let rating: Int
    let feedbackText: String
    let isBonusTipApplied: Bool
    let bonusAmount: Double
    let createdAt: Date
}