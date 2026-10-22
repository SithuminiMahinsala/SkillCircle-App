//
//  NotificationModel.swift
//  SkillCircle
//

import Foundation
import FirebaseFirestore

struct NotificationModel: Identifiable, Codable {
    let id: String
    let userId: String
    let title: String
    let message: String
    let type: String // "proposal", "message", "general"
    let timestamp: Date
    var isRead: Bool
    
    var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
    
    var iconName: String {
        switch type.lowercased() {
        case "proposal", "session":
            return "graduationcap.fill"
        case "message", "chat":
            return "bubble.left.fill"
        default:
            return "bell.fill"
        }
    }
}
