//
//  MockData+Sessions.swift
//  SkillCircle
//
//  Sample sessions. Extends the existing MockData without modifying it.
//

import Foundation

extension MockData {

    private static func date(_ day: Int, _ month: Int, hour: Int = 15) -> Date {
        Calendar.current.date(from: DateComponents(year: 2026, month: month, day: day, hour: hour, minute: 0)) ?? Date()
    }

    static let sessions: [TutoringSession] = [
        // Upcoming
        TutoringSession(id: UUID().uuidString, subject: "Statistics", tutorName: "Nuvi Shenaya",
                        location: "Library", date: date(24, 3), status: .upcoming),
        TutoringSession(id: UUID().uuidString, subject: "Statistics", tutorName: "Nuvi Shenaya",
                        location: "Library", date: date(24, 3), status: .upcoming),
        TutoringSession(id: UUID().uuidString, subject: "Statistics", tutorName: "Nuvi Shenaya",
                        location: "Library", date: date(24, 3), status: .upcoming),

        // Requests
        TutoringSession(id: UUID().uuidString, subject: "SwiftUI", tutorName: "Kavindu Perera",
                        location: "Cafeteria", date: date(27, 3, hour: 10), status: .requests),
        TutoringSession(id: UUID().uuidString, subject: "Python", tutorName: "Dinithi Silva",
                        location: "Lab 02", date: date(28, 3, hour: 14), status: .requests),

        // Completed
        TutoringSession(id: UUID().uuidString, subject: "Figma", tutorName: "Ishara Fernando",
                        location: "Library", date: date(10, 3, hour: 11), status: .completed),
        TutoringSession(id: UUID().uuidString, subject: "Git", tutorName: "Nuvi Shenaya",
                        location: "Online", date: date(2, 3, hour: 16), status: .completed)
    ]
}
