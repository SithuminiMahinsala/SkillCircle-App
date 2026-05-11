//
//  SignupView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                
                VStack(spacing: 8) {
                    Image("AppLogoSmall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 65, height: 65)
                    
                    Text("SkillCircle")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.deepIndigo)
                }
                .padding(.top, 50)
                
               
                VStack(spacing: 6) {
                    Text("Create Account")
                        .font(.system(size: 32, weight: .black))
                        .foregroundColor(.primary)
                    
                    Text("JOIN THE COMMUNITY")
                        .font(.caption)
                        .tracking(1.2)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 10)
                
                
                VStack(spacing: 16) {
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("University Email")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        TextField("Enter University Email", text: $email)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        SecureField("Enter Password", text: $password)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Confirm Password")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        SecureField("Re Enter Password", text: $confirmPassword)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                
                
                Button(action: {
                    
                    print("Attempting to sign up with: \(email)")
                }) {
                    Text("Sign Up")
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
                
                Spacer(minLength: 40)
                
                
                HStack(spacing: 4) {
                    Text("ALREADY HAVE AN ACCOUNT?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                    
                    }) {
                        Text("SIGN IN")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.deepIndigo)
                            .underline()
                    }
                }
                .padding(.bottom, 30)
            }
        }
        
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    SignupView()
}
