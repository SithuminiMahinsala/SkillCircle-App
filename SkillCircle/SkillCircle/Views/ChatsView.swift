//
//  ChatsView.swift
//  SkillCircle
//

import SwiftUI

struct ChatsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ChatsViewModel()
    @State private var showNewChatSheet: Bool = false
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 16) {
                // 1. Search Bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .font(.system(size: 16, weight: .bold))
                    
                    TextField("SEARCH CONVERSATIONS", text: $viewModel.searchText)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .textInputAutocapitalization(.never)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // 2. Chat List
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.filteredConversations) { conversation in
                            NavigationLink(destination: ChatDetailView(
                                partnerName: conversation.userName,
                                subjectName: conversation.subjectName,
                                isTeacherView: false,
                                chatId: conversation.id
                            )) {
                                ChatRowCard(conversation: conversation)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 80)
                }
            }
            
            // 3. Floating Action Button (New Message)
            Button(action: { showNewChatSheet = true }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color(red: 0.15, green: 0.22, blue: 0.62))
                    .cornerRadius(16)
                    .shadow(color: Color(red: 0.15, green: 0.22, blue: 0.62).opacity(0.35), radius: 8, x: 0, y: 4)
            }
            .padding(.trailing, 20)
            .padding(.bottom, 24)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationTitle("MY CHATS")
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
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { authViewModel.signOut() }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .sheet(isPresented: $showNewChatSheet) {
            NewChatSheetView(viewModel: viewModel)
        }
    }
}

// MARK: - Dynamic Real User Selection Sheet
struct NewChatSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: ChatsViewModel
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.availableUsers.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Searching for registered users...")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.gray)
                    }
                } else {
                    List(viewModel.availableUsers) { user in
                        Button(action: {
                            viewModel.createOrGetChat(
                                with: user.id,
                                partnerName: user.fullName,
                                subjectName: user.primarySubject
                            ) { _ in
                                dismiss()
                            }
                        }) {
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(user.fullName)
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.primary)
                                    
                                    Text(user.primarySubject)
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "bubble.right.fill")
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
            .navigationTitle("New Conversation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                }
            }
            .onAppear {
                viewModel.fetchUsers()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ChatsView()
            .environmentObject(AuthViewModel())
    }
}
