//
//  SetupProfileBasicView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct SetupProfileBasicView: View {
    var email: String
    var password: String
    
    @State private var fullName = ""
    @State private var bio = ""
    @State private var displayEmail = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    ZStack(alignment: .bottomTrailing) {
                        Circle()
                            .fill(Color(UIColor.systemGray5))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "person")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                            )
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .foregroundColor(.deepIndigo)
                            .background(Circle().fill(Color.white))
                            .offset(x: -5, y: -5)
                    }
                    
                    VStack(spacing: 4) {
                        Text("Upload Profile Picture")
                            .font(.headline)
                            .foregroundColor(.deepIndigo)
                        Text("Tap to select your photo")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 30)
                
                VStack(spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Full Name")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField("Enter Your Name", text: $fullName)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("University Email")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        TextField(email, text: $displayEmail)
                            .padding()
                            .background(Color(UIColor.systemGray6))
                            .cornerRadius(12)
                            .disabled(true)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Short Bio")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $bio)
                                .frame(height: 120)
                                .padding(8)
                                .background(Color(UIColor.systemGray6))
                                .cornerRadius(12)
                            
                            if bio.isEmpty {
                                Text("Tell Your Self")
                                    .foregroundColor(Color(UIColor.placeholderText))
                                    .padding(.top, 16)
                                    .padding(.leading, 12)
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer(minLength: 40)
                
                NavigationLink(destination: SetupProfileTeachView(email: email, password: password)) {
                    Text("Next")
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
                .padding(.bottom, 30)
            }
        }
        .navigationTitle("SET UP PROFILE")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    NavigationStack {
        SetupProfileBasicView(email: "test@nibm.lk", password: "password")
    }
}
