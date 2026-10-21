//
//  MySessionsViewModel.swift
//  SkillCircle
//

import Foundation
import Combine

class MySessionsViewModel: ObservableObject {
    @Published var selectedStatus: SessionStatus = .upcoming
    @Published var sessions: [TutoringSession] = []

    init(sessions: [TutoringSession] = MockData.sessions) {
        self.sessions = sessions
    }

    /// Sessions for the currently selected tab, soonest first
    var filteredSessions: [TutoringSession] {
        sessions
            .filter { $0.status == selectedStatus }
            .sorted { $0.date < $1.date }
    }

    func count(for status: SessionStatus) -> Int {
        sessions.filter { $0.status == status }.count
    }

    // TODO: replace with a Firestore fetch (collection "sessions") later.
}
