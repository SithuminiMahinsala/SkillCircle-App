//
//  ActiveSessionRouterView.swift
//  SkillCircle
//

import SwiftUI
import FirebaseAuth

struct ActiveSessionRouterView: View {
    let session: TutoringSession
    
    private var isTeacher: Bool {
        let currentUserId = Auth.auth().currentUser?.uid ?? ""
        let isProposer = (session.proposerId == currentUserId)
        
        // If current user proposed the session:
        // - "teaching" -> Teacher View (shows QR Code)
        // - "learning" -> Learner View (shows Camera Scanner)
        // If current user received the proposal:
        // - "teaching" -> Learner View (shows Camera Scanner)
        // - "learning" -> Teacher View (shows QR Code)
        let lowerGoal = session.goal.lowercased()
        if isProposer {
            return lowerGoal.contains("teach")
        } else {
            return lowerGoal.contains("learn")
        }
    }
    
    var body: some View {
        if isTeacher {
            ActiveSessionTeacherView()
        } else {
            ActiveSessionLearnerView()
        }
    }
}
