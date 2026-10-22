//
//  ChatConversation.swift
//  SkillCircle
//

import Foundation

struct ChatConversation: Identifiable {
    var id: String
    var participantId: String
    var userName: String
    var userAvatar: String
    var subjectName: String
    var lastMessage: String
    var timestamp: String
    var hasUnreadMessage: Bool
    var unreadCount: Int
    var isOnline: Bool
    
    // Convenience property for views referencing timeString
    var timeString: String {
        get { timestamp }
        set { timestamp = newValue }
    }
    
    // Convenience property for views referencing subjectTag
    var subjectTag: String {
        get { subjectName }
        set { subjectName = newValue }
    }
    
    init(
        id: String,
        participantId: String = "",
        userName: String,
        userAvatar: String = "person.circle.fill",
        subjectName: String = "GENERAL",
        lastMessage: String,
        timestamp: String = "Just now",
        hasUnreadMessage: Bool = false,
        unreadCount: Int = 0,
        isOnline: Bool = false
    ) {
        self.id = id
        self.participantId = participantId.isEmpty ? id : participantId
        self.userName = userName
        self.userAvatar = userAvatar
        self.subjectName = subjectName
        self.lastMessage = lastMessage
        self.timestamp = timestamp
        self.hasUnreadMessage = hasUnreadMessage || (unreadCount > 0)
        self.unreadCount = unreadCount
        self.isOnline = isOnline
    }
}
