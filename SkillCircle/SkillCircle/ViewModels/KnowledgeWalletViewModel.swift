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
import FirebaseFirestore
import FirebaseAuth

class KnowledgeWalletViewModel: ObservableObject {
    @Published var summary: WalletSummary = WalletSummary()
    @Published var transactions: [TokenTransaction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchWalletData()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchWalletData() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            // Fallback to mock data if user is not signed in during testing
            loadMockFallback()
            return
        }
        
        isLoading = true
        
        // 1. Fetch User Token Summary
        db.collection("users").document(currentUserId).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if let data = snapshot?.data() {
                let balance = data["tokensBalance"] as? Int ?? 14
                let earned = data["totalEarned"] as? Int ?? 18
                let spent = data["totalSpent"] as? Int ?? 4
                
                DispatchQueue.main.async {
                    self.summary = WalletSummary(balance: balance, totalEarned: earned, totalSpent: spent)
                }
            }
        }
        
        // 2. Attach Realtime Listener to Transactions Subcollection
        listenerRegistration = db.collection("users")
            .document(currentUserId)
            .collection("transactions")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        return
                    }
                    
                    guard let documents = snapshot?.documents else { return }
                    
                    self.transactions = documents.compactMap { doc -> TokenTransaction? in
                        let data = doc.data()
                        let id = doc.documentID
                        let title = data["title"] as? String ?? "Session Transaction"
                        let subjectName = data["subjectName"] as? String ?? "General"
                        let amount = data["amount"] as? Double ?? 1.0
                        let typeRaw = data["type"] as? String ?? "EARNED"
                        let type: TransactionType = (typeRaw == "SPENT") ? .spent : .earned
                        let dateString = data["dateString"] as? String ?? "Today"
                        let partnerName = data["partnerName"] as? String ?? "Peer"
                        let iconName = data["iconName"] as? String ?? "star.fill"
                        
                        return TokenTransaction(
                            id: id,
                            title: title,
                            subjectName: subjectName,
                            amount: amount,
                            type: type,
                            dateString: dateString,
                            partnerName: partnerName,
                            iconName: iconName
                        )
                    }
                }
            }
    }
    
    private func loadMockFallback() {
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
            )
        ]
        self.isLoading = false
    }
}
