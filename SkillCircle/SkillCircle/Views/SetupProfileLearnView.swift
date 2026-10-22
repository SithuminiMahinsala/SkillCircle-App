//
//  SetupProfileLearnView.swift
//  SkillCircle
//

import SwiftUI

struct SetupProfileLearnView: View {
    var email: String
    var password: String
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var searchText = ""
    @State private var selectedSkills: Set<String> = []
    @State private var isLoading: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    
    let skills = ["SWIFT", "JAVA", "MATH", "UI/UX", "STATISTICS", "PYTHON"]
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("SKILLS WHAT YOU LEARN")
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.5)
                .foregroundColor(.secondary)
                .padding(.horizontal, 24)
                .padding(.top, 20)
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.deepIndigo)
                TextField("SEARCH SUBJECTS", text: $searchText)
            }
            .padding()
            .background(Color(UIColor.systemGray6))
            .cornerRadius(24)
            .padding(.horizontal, 24)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(skills.filter { searchText.isEmpty || $0.contains(searchText.uppercased()) }, id: \.self) { skill in
                    Text(skill)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedSkills.contains(skill) ? Color.deepIndigo : Color.blue.opacity(0.8)
                        )
                        .cornerRadius(20)
                        .onTapGesture {
                            if selectedSkills.contains(skill) {
                                selectedSkills.remove(skill)
                            } else {
                                selectedSkills.insert(skill)
                            }
                        }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)
            
            Spacer()
            
            Button(action: completeProfile) {
                ZStack {
                    if isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Text("Complete Profile")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule()
                        .fill(Color.deepIndigo)
                        .shadow(color: Color.deepIndigo.opacity(0.3), radius: 10, x: 0, y: 5)
                )
            }
            .disabled(isLoading)
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
        .navigationTitle("SET UP PROFILE")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Registration Error", isPresented: $showErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func completeProfile() {
        isLoading = true
        let learningSkillsArray = Array(selectedSkills)
        
        authViewModel.register(
            email: email,
            password: password,
            learningSkills: learningSkillsArray
        ) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    // AuthViewModel updates userSession / isAuthenticated to trigger root view navigation
                    break
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showErrorAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SetupProfileLearnView(email: "test@nibm.lk", password: "password")
            .environmentObject(AuthViewModel())
    }
}
