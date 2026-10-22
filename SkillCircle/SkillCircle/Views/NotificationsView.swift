//
//  NotificationsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

//
//  NotificationsView.swift
//  SkillCircle
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = NotificationsViewModel()
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: - Filter Segmented Picker
            HStack(spacing: 0) {
                Button(action: { withAnimation { viewModel.selectedTab = 0 } }) {
                    Text("All")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(viewModel.selectedTab == 0 ? .white : Color(red: 0.35, green: 0.38, blue: 0.50))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            viewModel.selectedTab == 0 ?
                            Color(red: 0.25, green: 0.32, blue: 0.75) : Color.clear
                        )
                        .cornerRadius(12)
                }
                
                Button(action: { withAnimation { viewModel.selectedTab = 1 } }) {
                    Text("Unread")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(viewModel.selectedTab == 1 ? .white : Color(red: 0.35, green: 0.38, blue: 0.50))
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            viewModel.selectedTab == 1 ?
                            Color(red: 0.25, green: 0.32, blue: 0.75) : Color.clear
                        )
                        .cornerRadius(12)
                }
            }
            .padding(4)
            .background(Color(red: 0.90, green: 0.91, blue: 0.93))
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            
            // MARK: - Notifications List
            if viewModel.isLoading {
                Spacer()
                ProgressView()
                Spacer()
            } else if viewModel.filteredNotifications.isEmpty {
                Spacer()
                VStack(spacing: 12) {
                    Image(systemName: "bell.slash.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No Notifications")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(viewModel.filteredNotifications) { item in
                            NotificationRowCard(notification: item) {
                                viewModel.markAsRead(notificationId: item.id)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationTitle("NOTIFICATIONS")
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

// MARK: - Single Notification Card Subview
struct NotificationRowCard: View {
    let notification: NotificationModel
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 14) {
                // Circular Icon Container
                ZStack {
                    Circle()
                        .fill(Color(red: 0.88, green: 0.92, blue: 1.0))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: notification.iconName)
                        .font(.system(size: 20))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(notification.title)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        Text(notification.timeAgoString)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    
                    Text(notification.message)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    NavigationStack {
        NotificationsView()
    }
}
