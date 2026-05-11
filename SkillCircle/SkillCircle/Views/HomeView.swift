//
//  HomeView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct HomeView: View {
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    HomeTopHeaderView()
                    
                    HomeTitleAndSearchView(searchText: $searchText)
                    
                    UpcomingSessionCard()
                    
                    NavigationLink(destination: NearbyHelpView()) {
                        Text("Find Nearby Help")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Capsule()
                                    .fill(Color.deepIndigo)
                                    .shadow(color: Color.deepIndigo.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                    }
                    .padding(.horizontal, 24)
                    
                    RecommendedTutorsSection()
                }
                .padding(.bottom, 40)
            }
            .background(Color(UIColor.systemGray6).opacity(0.5).ignoresSafeArea())
        }
    }
}

#Preview {
    HomeView()
}
