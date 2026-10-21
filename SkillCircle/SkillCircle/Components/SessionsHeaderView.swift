//
//  SessionsHeaderView.swift
//  SkillCircle
//

import SwiftUI

struct SessionsHeaderView: View {
    var title: String = "MY SESSIONS"
    var onBack: (() -> Void)? = nil

    var body: some View {
        ZStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.heavy)
                .tracking(1.5)
                .foregroundColor(.deepIndigo)

            HStack {
                Button {
                    onBack?()
                } label: {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.deepIndigo)
                }

                Spacer()

                HStack(spacing: 14) {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 26))
                    Image(systemName: "bell.fill")
                        .font(.system(size: 22))
                }
                .foregroundColor(.deepIndigo)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}

#Preview {
    SessionsHeaderView()
}
