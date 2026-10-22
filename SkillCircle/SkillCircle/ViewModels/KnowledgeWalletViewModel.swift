//
//  KnowledgeWalletViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
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
        
        // Mock data matching app prototype state - replace with Firebase Firestore collection fetch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self = self else { return }
            self.transactions = [
                TokenTransaction(
                    id: "tx_1",
                    title: "Teaching Session Completed",
                    subjectName: "STATISTICS",
                    amount: 1,
                    type: .earned,
                    date: Date(),
                    partnerName: "Shenali"
                ),
                TokenTransaction(
                    id: "tx_2",
                    title: "Learning Session Completed",
                    subjectName: "MATHEMATICS",
                    amount: 1,
                    type: .spent,
                    date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                    partnerName: "Kavindu"
                ),
                TokenTransaction(
                    id: "tx_3",
                    title: "Teaching Session Completed",
                    subjectName: "STATISTICS",
                    amount: 2,
                    type: .earned,
                    date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(),
                    partnerName: "Nipuni"
                ),
                TokenTransaction(
                    id: "tx_4",
                    title: "Learning Session Completed",
                    subjectName: "PYTHON PROGRAMMING",
                    amount: 1,
                    type: .spent,
                    date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(),
                    partnerName: "Dilshan"
                )
            ]
            self.isLoading = false
        }
    }
}
