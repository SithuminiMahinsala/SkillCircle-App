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
    let amount: Double
    let type: TransactionType
    let dateString: String // e.g. "Feb 24, 2026"
    let partnerName: String
    let iconName: String // SF Symbol or custom designation
    
    var formattedAmount: String {
        let prefix = type == .earned ? "+" : "-"
        return String(format: "%@%.1f", prefix, abs(amount))
    }
}

struct WalletSummary {
    var balance: Int = 14
    var totalEarned: Int = 18
    var totalSpent: Int = 4
}
