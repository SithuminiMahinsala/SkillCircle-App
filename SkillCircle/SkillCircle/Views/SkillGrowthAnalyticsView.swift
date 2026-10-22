//
//  SkillGrowthAnalyticsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import SwiftUI

struct SkillBarData: Identifiable {
    let id = UUID()
    let subject: String
    let hoursTaught: CGFloat
    let hoursLearned: CGFloat
}

struct SkillGrowthAnalyticsView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let skillData: [SkillBarData] = [
        SkillBarData(subject: "Java", hoursTaught: 110, hoursLearned: 55),
        SkillBarData(subject: "Stats", hoursTaught: 135, hoursLearned: 45),
        SkillBarData(subject: "UI/UX", hoursTaught: 68, hoursLearned: 130),
        SkillBarData(subject: "Python", hoursTaught: 90, hoursLearned: 80)
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.96, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: 1. Total Academic Investment Card
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TOTAL ACADEMIC INVESTMENT")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color.gray.opacity(0.8))
                            
                            Text("42.5 Hours")
                                .font(.system(size: 30, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.98, green: 0.88, blue: 0.65))
                                .frame(width: 48, height: 48)
                            
                            Image(systemName: "academiccap.fill")
                                .font(.system(size: 22))
                                .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.05))
                        }
                    }
                    .padding(20)
                    .background(Color(red: 0.89, green: 0.90, blue: 0.96))
                    .cornerRadius(20)
                    
                    // MARK: 2. Skill Balance Chart Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Skill Balance")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        
                        VStack(spacing: 16) {
                            // Custom Bar Chart View
                            HStack(alignment: .bottom, spacing: 22) {
                                ForEach(skillData) { item in
                                    VStack(spacing: 8) {
                                        HStack(alignment: .bottom, spacing: 6) {
                                            // Hours Taught Bar
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(red: 0.15, green: 0.25, blue: 0.68))
                                                .frame(width: 14, height: item.hoursTaught)
                                            
                                            // Hours Learned Bar
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color(red: 0.05, green: 0.48, blue: 0.75))
                                                .frame(width: 14, height: item.hoursLearned)
                                        }
                                        .frame(height: 150, alignment: .bottom)
                                        
                                        Text(item.subject)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.gray)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 8)
                        }
                        .padding(20)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                        
                        // Chart Legend
                        HStack(spacing: 24) {
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(red: 0.15, green: 0.25, blue: 0.68))
                                    .frame(width: 8, height: 8)
                                Text("HOURS TAUGHT")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            }
                            
                            Spacer()
                            
                            HStack(spacing: 6) {
                                Circle()
                                    .fill(Color(red: 0.05, green: 0.48, blue: 0.75))
                                    .frame(width: 8, height: 8)
                                Text("HOURS LEARNED")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            }
                        }
                        .padding(.horizontal, 8)
                    }
                    
                    // MARK: 3. Tutor Insight Card
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green.opacity(0.15))
                                .frame(width: 36, height: 36)
                            
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Top 5% Tutor Insight")
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            (
                                Text("You are a Top 5% Tutor in Statistics this month! You've earned ")
                                    .foregroundColor(.gray)
                                + Text("15 tokens")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                + Text(" by helping 8 peers.")
                                    .foregroundColor(.gray)
                            )
                            .font(.system(size: 13))
                            .lineSpacing(2)
                        }
                    }
                    .padding(16)
                    .background(Color(red: 0.93, green: 0.94, blue: 0.96))
                    .cornerRadius(18)
                    
                    // MARK: 4. Bottom Metric Grid Cards
                    HStack(spacing: 14) {
                        // Peers Reached Card
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "person.3.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            
                            Text("128")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("PEERS REACHED")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.18, green: 0.26, blue: 0.68))
                        .cornerRadius(18)
                        
                        // Tutor Rating Card
                        VStack(alignment: .leading, spacing: 10) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                            
                            Text("A+")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text("TUTOR RATING")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white.opacity(0.8))
                        }
                        .padding(18)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(red: 0.38, green: 0.30, blue: 0.04))
                        .cornerRadius(18)
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
                Text("SKILL GROWTH ANALYTICS")
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
    }
}
