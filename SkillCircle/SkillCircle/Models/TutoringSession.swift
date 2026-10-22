//
//  TutoringSession.swift
//  SkillCircle
//

import Foundation

enum SessionStatus: String, Codable, CaseIterable, Identifiable {
    case upcoming = "Upcoming"
    case requests = "Requests"
    case completed = "Completed"
    
    var id: String { rawValue }
}

struct TutoringSession: Identifiable, Codable {
    var id: String
    var subject: String
    var tutorName: String
    var tutorImageName: String?
    var location: String
    var date: Date
    var status: SessionStatus
    
    // Properties for Teacher vs Learner routing
    var proposerId: String
    var goal: String
    
    // Convenience computed property for views referencing subjectName
    var subjectName: String {
        subject
    }
    
    init(
        id: String = UUID().uuidString,
        subject: String,
        tutorName: String,
        tutorImageName: String? = nil,
        location: String,
        date: Date,
        status: SessionStatus,
        proposerId: String = "",
        goal: String = "learning"
    ) {
        self.id = id
        self.subject = subject
        self.tutorName = tutorName
        self.tutorImageName = tutorImageName
        self.location = location
        self.date = date
        self.status = status
        self.proposerId = proposerId
        self.goal = goal
    }
}
