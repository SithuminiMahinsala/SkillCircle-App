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
            
            // MARK: Tab 0 - Home
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("HOME")
            }
            .tag(0)
            
            // MARK: Tab 1 - Sessions
            NavigationStack {
                ActiveSessionLearnerView()
            }
            .tabItem {
                Image(systemName: "calendar")
                Text("SESSIONS")
            }
            .tag(1)
            
            // MARK: Tab 2 - Chat
            NavigationStack {
                ChatsView()
            }
            .tabItem {
                Image(systemName: "message")
                Text("CHAT")
            }
            .tag(2)
            
            // MARK: Tab 3 - Wallet
            NavigationStack {
                KnowledgeWalletView()
            }
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
