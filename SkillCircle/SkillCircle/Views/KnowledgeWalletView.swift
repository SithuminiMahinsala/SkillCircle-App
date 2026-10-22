//
//  KnowledgeWalletView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import SwiftUI

struct KnowledgeWalletView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = KnowledgeWalletViewModel()
    @State private var showTransactionHistorySheet: Bool = false
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.96, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: 1. Token Balance Banner Card
                    VStack(spacing: 12) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.98, green: 0.92, blue: 0.78))
                                    .frame(width: 46, height: 46)
                                
                                Image(systemName: "star.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.18))
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("KNOWLEDGE TOKENS")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                Text("\(viewModel.summary.balance) Tokens")
                                    .font(.system(size: 26, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            }
                            
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("1 Token = 1 Hour Peer Knowledge Exchange")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.05))
                            Spacer()
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
                    
                    // MARK: 2. Analytics Navigation Cards
                    HStack(spacing: 14) {
                        NavigationLink(destination: SkillGrowthAnalyticsView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("SKILL GROWTH")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                    Text("Analytics")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                        }
                        
                        NavigationLink(destination: TokenTrendsView()) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("TOKEN TRENDS")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.18))
                                    Text("History")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                }
                                Spacer()
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.18))
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                        }
                    }
                    
                    // MARK: 3. Earnings vs Spend Overview
                    HStack(spacing: 14) {
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.green.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "arrow.down.left")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.green)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("EARNED")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.gray)
                                Text("\(viewModel.summary.totalEarned) Tokens")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                        
                        HStack(spacing: 12) {
                            ZStack {
                                Circle()
                                    .fill(Color.orange.opacity(0.12))
                                    .frame(width: 40, height: 40)
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.orange)
                            }
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text("SPENT")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.gray)
                                Text("\(viewModel.summary.totalSpent) Tokens")
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            }
                            Spacer()
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                    
                    // MARK: 4. Scrollable Transaction History Header & List
                    VStack(alignment: .leading, spacing: 14) {
                        HStack {
                            Text("TRANSACTION HISTORY")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            Spacer()
                            
                            // Trigger for Bottom Popup Sheet
                            Button(action: { showTransactionHistorySheet = true }) {
                                Text("View History")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            }
                        }
                        .padding(.horizontal, 4)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.transactions) { transaction in
                                HStack(spacing: 14) {
                                    ZStack {
                                        Circle()
                                            .fill(transaction.type == .earned ? Color.green.opacity(0.12) : Color.orange.opacity(0.12))
                                            .frame(width: 44, height: 44)
                                        
                                        Image(systemName: transaction.type == .earned ? "star.fill" : "book.fill")
                                            .font(.system(size: 18))
                                            .foregroundColor(transaction.type == .earned ? Color(red: 0.95, green: 0.75, blue: 0.18) : .orange)
                                    }
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(transaction.title)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                        
                                        HStack(spacing: 6) {
                                            Text(transaction.subjectName)
                                                .font(.system(size: 11, weight: .semibold))
                                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                            
                                            Text("•")
                                                .foregroundColor(.gray)
                                            
                                            Text(transaction.formattedDate)
                                                .font(.system(size: 11))
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Text("\(transaction.type == .earned ? "+" : "-")\(Int(transaction.amount))")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(transaction.type == .earned ? .green : .red)
                                }
                                .padding(14)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("KNOWLEDGE WALLET")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
        // MARK: Bottom Popup Presentation Sheet
        .sheet(isPresented: $showTransactionHistorySheet) {
            TransactionHistorySheetView()
                .presentationDetents([.fraction(0.88), .large])
                .presentationDragIndicator(.visible)
        }
    }
}
