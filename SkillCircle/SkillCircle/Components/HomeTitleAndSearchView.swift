//
//  HomeTitleAndSearchView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct HomeTitleAndSearchView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("FIND YOUR TUTOR")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.deepIndigo)
                .padding(.horizontal, 24)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.deepIndigo)
                TextField("SEARCH TUTORS", text: $searchText)
                    .font(.subheadline)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(24)
            .padding(.horizontal, 24)
            .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        }
    }
}

#Preview {
    HomeTitleAndSearchView(searchText: .constant(""))
}
