//
//  TransactionHistorySheetView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import SwiftUI

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case earned = "Earned"
    case spent = "Spent"
    
    var id: String { rawValue }
}

struct TransactionHistorySheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedFilter: TransactionFilter = .all
    
    // Mock transaction dataset matching design screens
    private let allTransactions: [TokenTransaction] = [
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
        ),
        TokenTransaction(
            id: "tx_5",
            title: "UI/UX Design - Teacher",
            subjectName: "UI/UX Design",
            amount: 1.0,
            type: .earned,
            dateString: "Feb 24, 2026",
            partnerName: "Amaya",
            iconName: "paintbrush.fill"
        ),
        TokenTransaction(
            id: "tx_6",
            title: "Mathematics - Teacher",
            subjectName: "Mathematics",
            amount: 1.5,
            type: .earned,
            dateString: "Feb 02, 2026",
            partnerName: "Kasun",
            iconName: "function"
        )
    ]
    
    var filteredTransactions: [TokenTransaction] {
        switch selectedFilter {
        case .all:
            return allTransactions
        case .earned:
            return allTransactions.filter { $0.type == .earned }
        case .spent:
            return allTransactions.filter { $0.type == .spent }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: 1. Navigation / Title Bar
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
                
                Spacer()
                
                Text("TRANSACTION HISTORY")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                
                Spacer()
                
                // Balance empty spacer to center title
                Color.clear
                    .frame(width: 28, height: 28)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            .background(Color.white)
            
            // MARK: 2. Filter Pills Segmented Control
            HStack(spacing: 12) {
                ForEach(TransactionFilter.allCases) { filter in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedFilter = filter
                        }
                    }) {
                        Text(filter.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(selectedFilter == filter ? .white : Color(red: 0.40, green: 0.44, blue: 0.55))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 28)
                            .background(
                                selectedFilter == filter
                                    ? Color(red: 0.22, green: 0.30, blue: 0.72)
                                    : Color.clear
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(6)
            .background(Color(red: 0.94, green: 0.95, blue: 0.97))
            .cornerRadius(24)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // MARK: 3. Scrollable Transactions List
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(filteredTransactions) { transaction in
                        HStack(spacing: 16) {
                            
                            // Category Icon Container
                            ZStack {
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 0.96, green: 0.97, blue: 0.99))
                                    .frame(width: 52, height: 52)
                                
                                Image(systemName: transaction.iconName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(
                                        transaction.subjectName.contains("Java") ? .orange :
                                        transaction.subjectName.contains("Python") ? .red :
                                        transaction.subjectName.contains("UI/UX") ? Color(red: 0.22, green: 0.30, blue: 0.72) :
                                        Color(red: 0.15, green: 0.25, blue: 0.68)
                                    )
                            }
                            
                            // Title & Date
                            VStack(alignment: .leading, spacing: 4) {
                                Text(transaction.title)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                
                                Text(transaction.dateString)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // Amount (+1.0 / -1.0)
                            Text(transaction.formattedAmount)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(
                                    transaction.type == .earned
                                        ? Color(red: 0.20, green: 0.70, blue: 0.35)
                                        : Color(red: 0.90, green: 0.25, blue: 0.25)
                                )
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 4)
                .padding(.bottom, 30)
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
    }
}
