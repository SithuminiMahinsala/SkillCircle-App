//
//  TutoringSession.swift
//  SkillCircle
//

import Foundation

enum SessionStatus: String, Codable, CaseIterable, Identifiable {
    case upcoming  = "Upcoming"
    case requests  = "Requests"
    case completed = "Completed"

    var id: String { rawValue }
}

struct TutoringSession: Identifiable, Codable, Hashable {
    var id: String = UUID().uuidString
    var subject: String
    var tutorName: String
    var tutorImageName: String?      // asset name; nil -> initials placeholder
    var location: String
    var date: Date
    var status: SessionStatus
}
