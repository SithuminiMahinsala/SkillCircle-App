//
//  SettingsViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

//
//  SettingsViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseAuth

class SettingsViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var avatarUrl: String? = nil
    @Published var isVerified: Bool = true
    @Published var enableFaceID: Bool = false
    @Published var enableTouchID: Bool = false
    @Published var isLoading: Bool = false
    
    private let db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    init() {
        fetchUserProfile()
    }
    
    deinit {
        listenerRegistration?.remove()
    }
    
    func fetchUserProfile() {
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        isLoading = true
        
        listenerRegistration = db.collection("users").document(currentUserId)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.isLoading = false
                    
                    if let data = snapshot?.data() {
                        self.fullName = data["fullName"] as? String ?? (Auth.auth().currentUser?.displayName ?? "SkillCircle User")
                        self.email = data["email"] as? String ?? (Auth.auth().currentUser?.email ?? "")
                        self.avatarUrl = data["avatarUrl"] as? String
                        self.isVerified = data["isVerified"] as? Bool ?? true
                    }
                }
            }
    }
}
