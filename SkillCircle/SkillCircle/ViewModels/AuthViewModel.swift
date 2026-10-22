//
//  AuthViewModel.swift
//  SkillCircle
//

import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var email: String = "" {
        didSet { emailText = email }
    }
    @Published var password: String = "" {
        didSet { passwordText = password }
    }
    @Published var fullName: String = "" {
        didSet { fullNameText = fullName }
    }
    
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var fullNameText: String = ""
    
    @Published var isLoading: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var currentUser: FirebaseAuth.User? = nil
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.currentUser = Auth.auth().currentUser
        self.isAuthenticated = (Auth.auth().currentUser != nil)
        
        // Listen to live Firebase Auth state transitions
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async {
                self?.currentUser = user
                self?.isAuthenticated = (user != nil)
            }
        }
    }
    
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    func login(email emailInput: String, password passwordInput: String, completion: @escaping (Bool) -> Void = { _ in }) {
        self.email = emailInput
        self.password = passwordInput
        loginUser(completion: completion)
    }
    
    func login() {
        loginUser { _ in }
    }
    
    func login(completion: @escaping (Bool) -> Void) {
        loginUser(completion: completion)
    }
    
    func loginUser(completion: @escaping (Bool) -> Void = { _ in }) {
        let activeEmail = email.isEmpty ? emailText : email
        let activePassword = password.isEmpty ? passwordText : password
        
        guard !activeEmail.trimmingCharacters(in: .whitespaces).isEmpty,
              !activePassword.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please enter email and password."
            completion(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: activeEmail, password: activePassword) { [weak self] authResult, error in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self.currentUser = authResult?.user
                    self.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }
    
    func signUp() {
        registerUser { _ in }
    }
    
    func register() {
        registerUser { _ in }
    }
    
    func registerUser(completion: @escaping (Bool) -> Void = { _ in }) {
        let activeEmail = email.isEmpty ? emailText : email
        let activePassword = password.isEmpty ? passwordText : password
        let activeName = fullName.isEmpty ? fullNameText : fullName
        
        guard !activeEmail.trimmingCharacters(in: .whitespaces).isEmpty,
              !activePassword.trimmingCharacters(in: .whitespaces).isEmpty,
              !activeName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all registration fields."
            completion(false)
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        Auth.auth().createUser(withEmail: activeEmail, password: activePassword) { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
                return
            }
            
            guard let uid = authResult?.user.uid else { return }
            
            let userData: [String: Any] = [
                "uid": uid,
                "fullName": activeName,
                "email": activeEmail,
                "tokensBalance": 10,
                "totalEarned": 10,
                "totalSpent": 0,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            self.db.collection("users").document(uid).setData(userData) { error in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if let error = error {
                        self.errorMessage = error.localizedDescription
                        completion(false)
                    } else {
                        self.currentUser = authResult?.user
                        self.isAuthenticated = true
                        completion(true)
                    }
                }
            }
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        self.currentUser = nil
        self.isAuthenticated = false
    }
}
