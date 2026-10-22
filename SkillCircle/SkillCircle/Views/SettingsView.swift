//
//  SettingsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

//
//  SettingsView.swift
//  SkillCircle
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                
                // MARK: - Profile Avatar & Basic Info Header
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 110, height: 110)
                        
                        if let avatar = viewModel.avatarUrl, !avatar.isEmpty {
                            CustomAvatarImage(imageName: avatar, size: 110)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 110, height: 110)
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                    }
                    .clipShape(Circle())
                    
                    Text(viewModel.fullName.uppercased())
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    
                    Text(viewModel.email)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    // Verified Profile Badge
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(.green)
                        
                        Text("Verified Profile")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(20)
                    .overlay(
                        Capsule()
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.top, 10)
                
                // MARK: - Section 1: ACCOUNT SETTINGS
                VStack(alignment: .leading, spacing: 10) {
                    Text("ACCOUNT SETTINGS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .padding(.horizontal, 8)
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "square.and.pencil", title: "Edit Personal Details")
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "lock.fill", title: "Update Password")
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "shield.fill", title: "Profile Security")
                    }
                    .background(Color.white)
                    .cornerRadius(18)
                }
                
                // MARK: - Section 2: APP PREFERENCES
                VStack(alignment: .leading, spacing: 10) {
                    Text("APP PREFERENCES")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .padding(.horizontal, 8)
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "bell.fill", title: "Notification Preferences")
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "globe", title: "App Language", trailingText: "English")
                    }
                    .background(Color.white)
                    .cornerRadius(18)
                }
                
                // MARK: - Section 3: BIOMETRIC SECURITY
                VStack(alignment: .leading, spacing: 10) {
                    Text("BIOMETRIC SECURITY")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .padding(.horizontal, 8)
                    
                    VStack(spacing: 0) {
                        SettingsToggleRow(icon: "faceid", title: "Enable Face ID", isOn: $viewModel.enableFaceID)
                        Divider().padding(.leading, 56)
                        SettingsToggleRow(icon: "touchid", title: "Enable Touch ID", isOn: $viewModel.enableTouchID)
                    }
                    .background(Color.white)
                    .cornerRadius(18)
                }
                
                // MARK: - Section 4: LEGAL & HELP
                VStack(alignment: .leading, spacing: 10) {
                    Text("LEGAL & HELP")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .padding(.horizontal, 8)
                    
                    VStack(spacing: 0) {
                        SettingsRow(icon: "questionmark.circle.fill", title: "Help & Support")
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "doc.text.fill", title: "Terms & Conditions")
                        Divider().padding(.leading, 56)
                        SettingsRow(icon: "info.circle.fill", title: "Privacy Policy")
                    }
                    .background(Color.white)
                    .cornerRadius(18)
                }
                
                // MARK: - Log Out Button
                Button(action: {
                    authViewModel.signOut()
                }) {
                    Text("Log Out")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(
                            Capsule()
                                .fill(Color(red: 1.0, green: 0.23, blue: 0.19))
                                .shadow(color: Color.red.opacity(0.35), radius: 8, x: 0, y: 4)
                        )
                }
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .padding(.horizontal, 20)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationTitle("SETTINGS")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
    }
}

// MARK: - Reusable Navigation Settings Row
struct SettingsRow: View {
    let icon: String
    let title: String
    var trailingText: String? = nil
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.92, green: 0.94, blue: 0.98))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
                
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                
                Spacer()
                
                if let trailingText = trailingText {
                    Text(trailingText)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary)
                }
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Reusable Toggle Settings Row
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.92, green: 0.94, blue: 0.98))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(Color(red: 0.22, green: 0.30, blue: 0.72))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
