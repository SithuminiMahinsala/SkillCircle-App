import SwiftUI
import Combine

class ActiveSessionLearnerViewModel: ObservableObject {
    @Published var session: ActiveSession
    @Published var formattedTime: String = "45 : 00"
    @Published var isVerified: Bool = false
    @Published var alertMessage: String? = nil
    @Published var showAlert: Bool = false
    
    private var timer: AnyCancellable?
    
    init(session: ActiveSession = ActiveSessionLearnerViewModel.mockSession) {
        self.session = session
        updateFormattedTime()
    }
    
    // MARK: - QR Verification Logic
    func verifyQRCode(_ payload: String) {
        guard !isVerified else { return }
        
        // Check if QR matches current session payload
        if payload.contains(session.id) || payload == session.qrCodePayload {
            isVerified = true
            session.status = .active
            lockTokenInEscrow()
            startTimer()
        } else {
            alertMessage = "Invalid QR Code. Please scan the QR code displayed by your tutor."
            showAlert = true
        }
    }
    
    // MARK: - Token Escrow Logic
    private func lockTokenInEscrow() {
        // Locks 1 Knowledge Token in Escrow upon successful scan
        print("1 Knowledge Token locked in escrow for session \(session.id)")
        
        // TODO: Update user wallet in Firebase Firestore:
        // Firestore.firestore().collection("users").document(currentUserId)
        //     .updateData(["tokensLockedInEscrow": FieldValue.increment(Int64(1))])
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
    
    // End Session Early Action
    func endSession() {
        timer?.cancel()
        session.status = .completed
    }
    
    //  Firebase Listener (Future Swap)
    func syncWithFirebase(sessionId: String) {
        // TODO: Replace mock sync with Firebase Firestore real-time listener
    }
    
    // Mock Data
    static let mockSession = ActiveSession(
        id: "SES-1029",
        subjectName: "STATISTICS",
        learnerName: "NUVI SHENAYA",
        durationMinutes: 45,
        remainingSeconds: 2700,
        status: .waiting,
        qrCodePayload: "skillcircle://session/SES-1029/verify"
    )
}