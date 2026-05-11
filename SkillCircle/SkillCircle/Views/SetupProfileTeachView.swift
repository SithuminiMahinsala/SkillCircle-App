//
//  SetupProfileTeachView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct SetupProfileTeachView: View {
    var email: String
    var password: String
    
    @State private var searchText = ""
    @State private var selectedSkills: Set<String> = []
    
    let skills = ["SWIFT", "JAVA", "MATH", "UI/UX", "STATISTICS", "PYTHON"]
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("SKILLS WHAT YOU TEACH")
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
                ForEach(skills, id: \.self) { skill in
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
            
            NavigationLink(destination: SetupProfileLearnView(email: email, password: password)) {
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
        .navigationTitle("SET UP PROFILE")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SetupProfileTeachView(email: "test@nibm.lk", password: "password")
    }
}
