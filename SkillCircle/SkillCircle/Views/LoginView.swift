//
//  LoginView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 1. App Logo & Name
                VStack(spacing: 8) {
                    Image("AppLogoSmall") // Ensure this image is in Assets.xcassets
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                    
                    Text("SkillCircle")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.deepIndigo)
                }
                .padding(.top, 50)
                
                // 2. Welcome Headers
                VStack(spacing: 6) {
                    Text("Welcome Back")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.primary)
                    
                    Text("JOIN THE COMMUNITY")
                        .font(.caption)
                        .tracking(1.2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
                
                // 3. Input Fields
                VStack(spacing: 16) {
                    
                    // Email Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("University Email")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter Your University Email", text: $email)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                    }
                    
                    // Password Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        SecureField("Enter Password", text: $password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                
                // 4. Main Sign In Button
                Button(action: {
                    // Firebase Auth login logic will be connected here
                    print("Attempting to sign in with: \(email)")
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Capsule()
                                .fill(Color.deepIndigo)
                                .shadow(color: Color.deepIndigo.opacity(0.3), radius: 10, x: 0, y: 5)
                        )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // 5. Biometric Authentication Section
                VStack(spacing: 12) {
                    Button(action: {
                        // LocalAuthentication framework logic goes here
                        print("Triggering FaceID / TouchID")
                    }) {
                        Image(systemName: "touchid") // Native iOS fingerprint symbol
                            .font(.system(size: 30))
                            .foregroundColor(.blue.opacity(0.6))
                            .padding(16)
                            .background(Circle().fill(Color.blue.opacity(0.1)))
                    }
                    
                    Button(action: {
                        // Triggers the same biometric logic
                    }) {
                        Text("SIGN IN WITH BIOMETRICS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.deepIndigo)
                    }
                }
                .padding(.top, 20)
                
                Spacer(minLength: 40)
                
                // 6. Footer Link to Sign Up
                HStack(spacing: 4) {
                    Text("DON'T HAVE AN ACCOUNT?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        // Logic to navigate to SignupView
                    }) {
                        Text("SIGN UP")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.deepIndigo)
                            .underline()
                    }
                }
                .padding(.bottom, 30)
            }
        }
        // Prevents the view from breaking when the keyboard pops up
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    LoginView()
}
