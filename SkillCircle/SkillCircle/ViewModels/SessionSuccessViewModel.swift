import SwiftUI
import Combine

class SessionSuccessViewModel: ObservableObject {
    @Published var rating: Int = 0
    @Published var feedbackText: String = "" {
        didSet {
            if feedbackText.count > maxCharacterCount {
                feedbackText = String(feedbackText.prefix(maxCharacterCount))
            }
        }
    }
    @Published var isBonusTipApplied: Bool = false
    @Published var isSubmitting: Bool = false
    @Published var isSubmittedSuccessfully: Bool = false
    
    let maxCharacterCount: Int = 500
    let summary: CompletedSessionSummary
    
    init(summary: CompletedSessionSummary = SessionSuccessViewModel.mockSummary) {
        self.summary = summary
    }
    
    // MARK: - Submit Feedback Logic
    func submitFeedback(completion: @escaping () -> Void) {
        guard rating > 0 else { return }
        
        isSubmitting = true
        
        let feedback = SessionFeedback(
            id: UUID().uuidString,
            sessionId: summary.sessionId,
            rating: rating,
            feedbackText: feedbackText,
            isBonusTipApplied: isBonusTipApplied,
            bonusAmount: isBonusTipApplied ? 0.5 : 0.0,
            createdAt: Date()
        )
        
        // Simulated network/Firebase submission delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self = self else { return }
            self.isSubmitting = false
            self.isSubmittedSuccessfully = true
            
            // TODO: Submit to Firebase Firestore:
            // let db = Firestore.firestore()
            // db.collection("session_feedback").document(feedback.id).setData([...])
            
            completion()
        }
    }
    
    // MARK: - Mock Data
    static let mockSummary = CompletedSessionSummary(
        sessionId: "SES-1029",
        subjectName: "STATISTICS",
        teacherName: "NUVI SHENAYA",
        durationMinutes: 45,
        tokensEarned: 1.0
    )
}