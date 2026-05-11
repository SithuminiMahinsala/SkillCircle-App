//
//  RecommendedTutorsSection.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct RecommendedTutorsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("RECOMMENDED TUTORS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(1.0)
                
                Spacer()
                
                Button(action: {}) {
                    Text("SEE ALL")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.deepIndigo)
                }
            }
            .padding(.horizontal, 24)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    RecommendedTutorCard(imageName: "TutorHirusha", name: "HIRUSHA", subject: "APPLIED PHYSICS", rating: "4.9")
                    RecommendedTutorCard(imageName: "TutorAmeliya", name: "AMELIYA", subject: "UI/UX DESIGN", rating: "4.1")
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 10)
            }
        }
    }
}

struct RecommendedTutorCard: View {
    var imageName: String
    var name: String
    var subject: String
    var rating: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
            
            VStack(spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(.deepIndigo)
                
                Text(subject)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .font(.caption2)
                    .foregroundColor(.green)
                Text(rating)
                    .font(.caption)
                    .fontWeight(.bold)
                Circle()
                    .fill(Color.yellow)
                    .frame(width: 6, height: 6)
            }
        }
        .padding(20)
        .frame(width: 150)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    RecommendedTutorsSection()
}
