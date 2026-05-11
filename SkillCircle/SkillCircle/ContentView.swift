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
                    MainTabView()
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
