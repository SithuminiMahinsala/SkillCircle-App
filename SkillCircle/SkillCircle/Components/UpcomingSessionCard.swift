//
//  UpcomingSessionCard.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct UpcomingSessionCard: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("UPCOMING SESSION")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.secondary)
                    .tracking(1.0)
                
                Spacer()
                
                Text("STARTS IN 45 MINS")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(.deepIndigo)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.deepIndigo.opacity(0.15))
                    .cornerRadius(12)
            }
            
            HStack(spacing: 16) {
                Image("TutorNuvi")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("NUVI SHENAYA")
                        .font(.headline)
                        .foregroundColor(.deepIndigo)
                    Text("Statistics")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                NavigationLink(destination: SessionDetailsView()) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundColor(.deepIndigo)
                }
            }
            
            ZStack {
                Image("MapPlaceholder")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 120)
                    .cornerRadius(16)
                    .clipped()
                
                VStack(spacing: 0) {
                    Text("Library")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.deepIndigo)
                        .cornerRadius(8)
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.title2)
                        .foregroundColor(.deepIndigo)
                        .background(Circle().fill(Color.white))
                        .offset(y: -4)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 10)
        .padding(.horizontal, 24)
    }
}

#Preview {
    NavigationStack {
        UpcomingSessionCard()
    }
}
