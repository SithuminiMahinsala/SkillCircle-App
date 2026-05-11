//
//  MainTabView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("HOME")
                }
                .tag(0)
            
            
            Text("Sessions View Coming Soon")
                .tabItem {
                    Image(systemName: "calendar")
                    Text("SESSIONS")
                }
                .tag(1)
            
            
            Text("Chat View Coming Soon")
                .tabItem {
                    Image(systemName: "message")
                    Text("CHAT")
                }
                .tag(2)
            
            
            Text("Wallet View Coming Soon")
                .tabItem {
                    Image(systemName: "wallet.pass")
                    Text("WALLET")
                }
                .tag(3)
        }
       
        .accentColor(.deepIndigo)
    }
}

#Preview {
    MainTabView()
}
