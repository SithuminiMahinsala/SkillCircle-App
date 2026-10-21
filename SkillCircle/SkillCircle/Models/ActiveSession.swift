import Foundation

struct ActiveSession: Identifiable, Codable {
    let id: String
    let subjectName: String
    let learnerName: String
    let durationMinutes: Int
    var remainingSeconds: Int
    var status: SessionStatus
    let qrCodePayload: String
    
    enum SessionStatus: String, Codable {
        case active = "ACTIVE"
        case waiting = "WAITING"
        case completed = "COMPLETED"
    }
}