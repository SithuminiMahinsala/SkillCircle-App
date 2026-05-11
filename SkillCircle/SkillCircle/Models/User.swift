//
//  User.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var university: String
    var teachSkills: [String]
    var seekSkills: [String]
    var tokenBalance: Double
}
