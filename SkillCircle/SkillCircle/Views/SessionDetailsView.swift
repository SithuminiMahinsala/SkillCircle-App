//
//  SessionDetailsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct SessionDetailsView: View {
    var body: some View {
        VStack {
            Text("Session Details")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.deepIndigo)
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SessionDetailsView()
    }
}
