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
    
    // Convenience property for root view navigation checks
    var userSession: FirebaseAuth.User? {
        return currentUser
    }
    
    private let db = Firestore.firestore()
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    
    init() {
        self.currentUser = Auth.auth().currentUser
        self.isAuthenticated = (Auth.auth().currentUser != nil)
        
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
    
    // MARK: - Login Overloads
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
    
    // MARK: - Registration Overloads
    func register(
        email emailInput: String,
        password passwordInput: String,
        fullName fullNameInput: String = "",
        learningSkills: [String] = [],
        completion: @escaping (Bool) -> Void = { _ in }
    ) {
        self.email = emailInput
        self.password = passwordInput
        if !fullNameInput.isEmpty { self.fullName = fullNameInput }
        registerUser(learningSkills: learningSkills, completion: completion)
    }
    
    func register(
        email emailInput: String,
        password passwordInput: String,
        learningSkills: [String] = [],
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        self.email = emailInput
        self.password = passwordInput
        registerUser(learningSkills: learningSkills) { success in
            if success {
                completion(.success(()))
            } else {
                let err = NSError(
                    domain: "AuthError",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: self.errorMessage ?? "Registration failed"]
                )
                completion(.failure(err))
            }
        }
    }
    
    func signUp() {
        registerUser { _ in }
    }
    
    func register() {
        registerUser { _ in }
    }
    
    func registerUser(learningSkills: [String] = [], completion: @escaping (Bool) -> Void = { _ in }) {
        let activeEmail = email.isEmpty ? emailText : email
        let activePassword = password.isEmpty ? passwordText : password
        let activeName = fullName.isEmpty ? (fullNameText.isEmpty ? "SkillCircle Student" : fullNameText) : fullName
        
        guard !activeEmail.trimmingCharacters(in: .whitespaces).isEmpty,
              !activePassword.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in email and password."
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
                "learningSkills": learningSkills,
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
