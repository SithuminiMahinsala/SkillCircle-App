//
//  HomeTopHeaderView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct HomeTopHeaderView: View {
    var body: some View {
        HStack {
            Text("HELLO, SHENALI")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.deepIndigo)
            
            Spacer()
            
            HStack(spacing: 16) {
                Image("UserProfilePhoto")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Image(systemName: "bell")
                    .font(.title2)
                    .foregroundColor(.deepIndigo)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
    }
}

#Preview {
    HomeTopHeaderView()
}
