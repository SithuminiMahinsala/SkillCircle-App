//
//  NearbyHelpView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct NearbyHelpView: View {
    var body: some View {
        VStack {
            Text("Map View Coming Soon")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.deepIndigo)
        }
        .navigationTitle("Nearby Tutors")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NearbyHelpView()
    }
}
