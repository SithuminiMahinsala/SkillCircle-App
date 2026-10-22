//
//  KnowledgeWallet.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import Foundation

enum TransactionType: String, Codable {
    case earned = "EARNED"
    case spent = "SPENT"
}

struct TokenTransaction: Identifiable, Codable {
    let id: String
    let title: String
    let subjectName: String
    let amount: Int
    let type: TransactionType
    let date: Date
    let partnerName: String
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

struct WalletSummary {
    var balance: Int = 14
    var totalEarned: Int = 18
    var totalSpent: Int = 4
}
