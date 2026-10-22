//
//  KnowledgeWalletViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

//
//  KnowledgeWalletViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine

class KnowledgeWalletViewModel: ObservableObject {
    @Published var summary: WalletSummary = WalletSummary()
    @Published var transactions: [TokenTransaction] = []
    @Published var isLoading: Bool = false
    
    init() {
        loadWalletData()
    }
    
    func loadWalletData() {
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.transactions = [
                TokenTransaction(
                    id: "tx_1",
                    title: "UI/UX Design - Teacher",
                    subjectName: "UI/UX Design",
                    amount: 1.0,
                    type: .earned,
                    dateString: "Feb 24, 2026",
                    partnerName: "Shenali",
                    iconName: "paintbrush.fill"
                ),
                TokenTransaction(
                    id: "tx_2",
                    title: "Java - Learner",
                    subjectName: "Java",
                    amount: 1.0,
                    type: .spent,
                    dateString: "Feb 10, 2026",
                    partnerName: "Kavindu",
                    iconName: "terminal.fill"
                ),
                TokenTransaction(
                    id: "tx_3",
                    title: "Mathematics - Teacher",
                    subjectName: "Mathematics",
                    amount: 1.5,
                    type: .earned,
                    dateString: "Feb 02, 2026",
                    partnerName: "Nipuni",
                    iconName: "function"
                ),
                TokenTransaction(
                    id: "tx_4",
                    title: "Python - Learner",
                    subjectName: "Python",
                    amount: 1.0,
                    type: .spent,
                    dateString: "Feb 10, 2026",
                    partnerName: "Dilshan",
                    iconName: "terminal.fill"
                )
            ]
            self.isLoading = false
        }
    }
}
