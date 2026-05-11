//
//  AuthViewModel.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import Combine
import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var errorMessage: String?
    
    init() {
        // Automatically check if the user is already logged in when the app starts
        fetchUser()
    }
    
    // MARK: - Sign In
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Failed to log in: \(error.localizedDescription)")
                return
            }
            
            print("Successfully logged in!")
            self?.fetchUser()
        }
    }
    
    // MARK: - Sign Up
    func register(email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                print("Failed to register: \(error.localizedDescription)")
                return
            }
            
            guard let uid = result?.user.uid else { return }
            
            // 1. Create the database profile using your User model
            let newUser = User(
                id: uid,
                name: "New Student", // Can be updated in a profile setup screen later
                email: email,
                university: "NIBM",
                teachSkills: [],
                seekSkills: [],
                tokenBalance: 50.0 // Give them a starting bonus of tokens
            )
            
            // 2. Save it to Firestore
            self?.saveUserData(user: newUser)
        }
    }
    
    // MARK: - Sign Out
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil
            print("Successfully signed out")
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Database Helpers
    private func saveUserData(user: User) {
        let db = Firestore.firestore()
        
        db.collection("users").document(user.id).setData([
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "university": user.university,
            "teachSkills": user.teachSkills,
            "seekSkills": user.seekSkills,
            "tokenBalance": user.tokenBalance
        ]) { [weak self] error in
            if let error = error {
                print("Error saving user data: \(error.localizedDescription)")
                return
            }
            print("Successfully saved user data to Firestore!")
            self?.fetchUser()
        }
    }
    
    private func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else { return }
            
            // Map the Firestore data back to the Swift User model
            self?.currentUser = User(
                id: data["id"] as? String ?? uid,
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                university: data["university"] as? String ?? "",
                teachSkills: data["teachSkills"] as? [String] ?? [],
                seekSkills: data["seekSkills"] as? [String] ?? [],
                tokenBalance: data["tokenBalance"] as? Double ?? 0.0
            )
        }
    }
}
