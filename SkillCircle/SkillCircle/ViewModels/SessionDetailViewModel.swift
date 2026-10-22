//
//  SessionDetailViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//



import SwiftUI
import Combine

class SessionDetailViewModel: ObservableObject {
    @Published var session: SessionDetailModel
    @Published var isStarting: Bool = false
    @Published var showCancelAlert: Bool = false
    
    init(session: SessionDetailModel? = nil) {
        self.session = session ?? SessionDetailModel(
            id: "sess_101",
            subjectName: "STATISTICS",
            status: SessionDetailStatus.confirmed,
            teacherName: "NUVI SHENAYA",
            teacherAvatarUrl: nil,
            learnerName: "SHENALI MENON",
            learnerAvatarUrl: nil,
            dateString: "24 MAR 2026",
            timeString: "15 : 00 - 16 : 00",
            locationName: "Library"
        )
    }
    
    func cancelSession(completion: @escaping () -> Void) {
        completion()
    }
}
