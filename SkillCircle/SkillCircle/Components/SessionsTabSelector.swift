//
//  SessionsTabSelector.swift
//  SkillCircle
//

import SwiftUI

struct SessionsTabSelector: View {
    @Binding var selection: SessionStatus
    @Namespace private var pill

    var body: some View {
        HStack(spacing: 0) {
            ForEach(SessionStatus.allCases) { status in
                let isSelected = selection == status

                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        selection = status
                    }
                } label: {
                    Text(status.rawValue)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : .sessionMutedText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background {
                            if isSelected {
                                Capsule()
                                    .fill(Color.deepIndigo)
                                    .shadow(color: Color.deepIndigo.opacity(0.35), radius: 8, x: 0, y: 4)
                                    .matchedGeometryEffect(id: "pill", in: pill)
                            }
                        }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 24)
    }
}

#Preview {
    SessionsTabSelector(selection: .constant(.upcoming))
        .padding(.vertical)
        .background(Color.sessionBackground)
}
