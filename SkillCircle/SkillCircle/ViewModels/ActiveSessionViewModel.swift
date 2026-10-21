import SwiftUI
import Combine

class ActiveSessionViewModel: ObservableObject {
    @Published var session: ActiveSession
    @Published var formattedTime: String = "45 : 00"
    
    private var timer: AnyCancellable?
    
    init(session: ActiveSession = ActiveSessionViewModel.mockSession) {
        self.session = session
        updateFormattedTime()
        startTimer()
    }
    
    // MARK: - Timer Logic
    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if self.session.remainingSeconds > 0 {
                    self.session.remainingSeconds -= 1
                    self.updateFormattedTime()
                } else {
                    self.session.status = .completed
                    self.timer?.cancel()
                }
            }
    }
    
    private func updateFormattedTime() {
        let minutes = session.remainingSeconds / 60
        let seconds = session.remainingSeconds % 60
        formattedTime = String(format: "%02d : %02d", minutes, seconds)
    }
    
    // MARK: - Firebase Listener Integration (Future Swap)
    func listenToFirebaseSession(sessionId: String) {
        // TODO: Replace with Firebase Firestore real-time listener:
        // Firestore.firestore().collection("sessions").document(sessionId)
        //     .addSnapshotListener { document, error in ... }
    }
    
    // MARK: - Mock Data
    static let mockSession = ActiveSession(
        id: "SES-1029",
        subjectName: "STATISTICS",
        learnerName: "SHENALI GAMAGE",
        durationMinutes: 45,
        remainingSeconds: 2700,
        status: .active,
        qrCodePayload: "skillcircle://session/SES-1029/verify"
    )
}