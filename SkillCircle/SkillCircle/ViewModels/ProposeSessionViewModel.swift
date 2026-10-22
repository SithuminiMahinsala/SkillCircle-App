//
//  ProposeSessionViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import MapKit
import FirebaseFirestore
import FirebaseAuth

struct ProposeSessionFormState {
    var goal: SessionGoal = .learning
    var subjectName: String = "STATISTICS"
    var selectedDate: Date = Date()
    var startTime: Date = Date()
    var endTime: Date = Date()
    var method: SessionMethod = .physical
    var physicalLocationType: PhysicalLocationType = .indoor
    
    var building: String = "Main Library"
    var floor: String = "2nd Floor"
    var room: String = "Study Room 3"
    
    var latitude: Double = 6.9271
    var longitude: Double = 79.8612
    var meetingLink: String = ""
    var estimatedTokens: Int = 1
}

class ProposeSessionViewModel: ObservableObject {
    @Published var form = ProposeSessionFormState()
    @Published var isSubmitting: Bool = false
    @Published var mapCameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
            span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        )
    )
    
    let chatId: String
    private let db = Firestore.firestore()
    
    init(subjectName: String = "STATISTICS", chatId: String = "") {
        self.chatId = chatId
        self.form.subjectName = subjectName
    }
    
    func submitProposal(completion: @escaping () -> Void) {
        guard !chatId.isEmpty, let currentUserId = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        isSubmitting = true
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        let dateText = dateFormatter.string(from: form.selectedDate)
        
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        let timeRange = "\(timeFormatter.string(from: form.startTime)) - \(timeFormatter.string(from: form.endTime))"
        
        let locationText: String
        if form.method == .physical {
            if form.physicalLocationType == .indoor {
                locationText = "\(form.building), Floor \(form.floor), Room \(form.room)"
            } else {
                locationText = "Pinned Location (\(String(format: "%.4f", form.latitude)), \(String(format: "%.4f", form.longitude)))"
            }
        } else {
            locationText = form.meetingLink.isEmpty ? "Online Meeting" : form.meetingLink
        }
        
        let proposalId = UUID().uuidString
        let sessionId = UUID().uuidString
        
        let proposalData: [String: Any] = [
            "id": proposalId,
            "sessionId": sessionId,
            "proposerId": currentUserId,
            "goal": form.goal.rawValue,
            "dateText": dateText,
            "timeRange": timeRange,
            "location": locationText,
            "method": form.method.rawValue,
            "status": "Awaiting for Confirmation"
        ]
        
        let messageData: [String: Any] = [
            "senderId": currentUserId,
            "proposal": proposalData,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        // 1. Save proposal message in chat thread
        db.collection("chats").document(chatId).collection("messages").addDocument(data: messageData) { [weak self] error in
            guard let self = self, error == nil else {
                DispatchQueue.main.async { self?.isSubmitting = false }
                completion()
                return
            }
            
            // 2. Fetch parent chat document to get partner details & participants
            self.db.collection("chats").document(self.chatId).getDocument { chatDoc, _ in
                let chatData = chatDoc?.data() ?? [:]
                let participants = chatData["participants"] as? [String] ?? [currentUserId]
                let partnerName = chatData["partnerName"] as? String ?? "Tutor"
                
                let sessionRecord: [String: Any] = [
                    "id": sessionId,
                    "proposalId": proposalId,
                    "chatId": self.chatId,
                    "proposerId": currentUserId,
                    "goal": self.form.goal.rawValue,
                    "participants": participants,
                    "partnerName": partnerName,
                    "subjectName": self.form.subjectName,
                    "dateText": dateText,
                    "timeRange": timeRange,
                    "location": locationText,
                    "method": self.form.method.rawValue,
                    "status": "Awaiting for Confirmation",
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                // 3. Write record to top-level 'sessions' collection
                self.db.collection("sessions").document(sessionId).setData(sessionRecord) { _ in
                    self.db.collection("chats").document(self.chatId).setData([
                        "lastMessage": "Sent a session proposal",
                        "updatedAt": FieldValue.serverTimestamp()
                    ], merge: true)
                    
                    DispatchQueue.main.async {
                        self.isSubmitting = false
                        completion()
                    }
                }
            }
        }
    }
}
