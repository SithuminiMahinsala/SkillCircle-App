//
//  SessionDetail.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//


import Foundation

enum SessionDetailStatus: String, Codable {
    case confirmed = "CONFIRMED"
    case pending = "PENDING"
    case completed = "COMPLETED"
    case cancelled = "CANCELLED"
    
    var badgeText: String {
        return "STATUS : \(self.rawValue)"
    }
}

struct SessionDetailModel: Identifiable, Codable {
    let id: String
    let subjectName: String
    let status: SessionDetailStatus
    let teacherName: String
    let teacherAvatarUrl: String?
    let learnerName: String
    let learnerAvatarUrl: String?
    let dateString: String
    let timeString: String
    let locationName: String
}
