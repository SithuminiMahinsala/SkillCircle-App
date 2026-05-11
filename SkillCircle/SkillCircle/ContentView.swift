//
//  ContentView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        Group {
           
            if authViewModel.currentUser != nil {
               
                VStack(spacing: 20) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.green)
                    
                    Text("Welcome to SkillCircle!")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("You are successfully logged in.")
                        .foregroundColor(.secondary)
                    
                    Button("Sign Out") {
                        authViewModel.signOut()
                    }
                    .padding(.top, 20)
                }
                
            } else {
              
                LandingView()
            }
        }
        
        .environmentObject(authViewModel)
    }
}

#Preview {
    ContentView()
}
