//
//  MySessionsView.swift
//  SkillCircle
//

import SwiftUI

struct MySessionsView: View {
    @StateObject private var viewModel = MySessionsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SessionsHeaderView(onBack: { dismiss() })

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        SessionsTabSelector(selection: $viewModel.selectedStatus)
                            .padding(.top, 16)

                        if viewModel.filteredSessions.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.filteredSessions) { session in
                                    SessionCard(session: session)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .background(Color.sessionBackground.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 44))
                .foregroundColor(.deepIndigo.opacity(0.6))
            Text("No \(viewModel.selectedStatus.rawValue.lowercased()) sessions")
                .font(.headline)
                .foregroundColor(.sessionMutedText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }
}

#Preview {
    MySessionsView()
}