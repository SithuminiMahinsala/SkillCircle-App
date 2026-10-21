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
        TutoringSession(subject: "Statistics", tutorName: "Nuvi Shenaya", tutorImageName: nil,
                        location: "Library", date: date(24, 3), status: .upcoming),
        TutoringSession(subject: "Statistics", tutorName: "Nuvi Shenaya", tutorImageName: nil,
                        location: "Library", date: date(24, 3), status: .upcoming),
        TutoringSession(subject: "Statistics", tutorName: "Nuvi Shenaya", tutorImageName: nil,
                        location: "Library", date: date(24, 3), status: .upcoming),

        // Requests
        TutoringSession(subject: "SwiftUI", tutorName: "Kavindu Perera", tutorImageName: nil,
                        location: "Cafeteria", date: date(27, 3, hour: 10), status: .requests),
        TutoringSession(subject: "Python", tutorName: "Dinithi Silva", tutorImageName: nil,
                        location: "Lab 02", date: date(28, 3, hour: 14), status: .requests),

        // Completed
        TutoringSession(subject: "Figma", tutorName: "Ishara Fernando", tutorImageName: nil,
                        location: "Library", date: date(10, 3, hour: 11), status: .completed),
        TutoringSession(subject: "Git", tutorName: "Nuvi Shenaya", tutorImageName: nil,
                        location: "Online", date: date(2, 3, hour: 16), status: .completed)
    ]
}
