//
//  HomeTopHeaderView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct HomeTopHeaderView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var userName: String = ""
    @State private var userAvatarUrl: String? = nil
    
    private let db = Firestore.firestore()

    var body: some View {
        HStack {
            Text("HELLO, \(displayName.uppercased())")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.deepIndigo)
            
            Spacer()
            
            HStack(spacing: 16) {
                // Profile Avatar -> Navigates to SettingsView
                NavigationLink(destination: SettingsView()) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.15))
                            .frame(width: 40, height: 40)
                        
                        if let avatar = userAvatarUrl, !avatar.isEmpty {
                            CustomAvatarImage(imageName: avatar, size: 40)
                        } else {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.deepIndigo)
                        }
                    }
                    .clipShape(Circle())
                }

                // Bell Icon -> Navigates to NotificationsView
                NavigationLink(destination: NotificationsView()) {
                    Image(systemName: "bell")
                        .font(.title2)
                        .foregroundColor(.deepIndigo)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 10)
        .onAppear {
            fetchUserProfile()
        }
    }
    
    private var displayName: String {
        if !userName.trimmingCharacters(in: .whitespaces).isEmpty {
            return userName
        } else if !authViewModel.fullName.trimmingCharacters(in: .whitespaces).isEmpty {
            return authViewModel.fullName
        } else {
            return "STUDENT"
        }
    }
    
    private func fetchUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(uid).addSnapshotListener { snapshot, error in
            if let data = snapshot?.data() {
                DispatchQueue.main.async {
                    self.userName = data["fullName"] as? String ?? ""
                    self.userAvatarUrl = data["avatarUrl"] as? String
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        HomeTopHeaderView()
            .environmentObject(AuthViewModel())
    }
}
