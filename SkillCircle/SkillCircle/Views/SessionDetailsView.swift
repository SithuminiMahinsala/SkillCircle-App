//
//  SessionDetailsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct SessionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: SessionDetailViewModel
    
    @State private var navigateToChat: Bool = false
    @State private var navigateToActiveSession: Bool = false
    @State private var navigateToLocation: Bool = false
    
    init(session: SessionDetailModel? = nil) {
        _viewModel = StateObject(wrappedValue: SessionDetailViewModel(session: session))
    }
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.96, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 22) {
                    statusBadge
                    subjectDetailsCard
                    locationCard
                    actionButtons
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 30)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("SESSION DETAILS")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
        .alert("Cancel Session", isPresented: $viewModel.showCancelAlert) {
            Button("Yes, Cancel", role: .destructive) {
                viewModel.cancelSession {
                    dismiss()
                }
            }
            Button("Keep Session", role: .cancel) { }
        } message: {
            Text("Are you sure you want to cancel this scheduled session?")
        }
        .navigationDestination(isPresented: $navigateToChat) {
            ChatDetailView(partnerName: viewModel.session.learnerName, subjectName: viewModel.session.subjectName)
        }
        .navigationDestination(isPresented: $navigateToActiveSession) {
            ActiveSessionLearnerView()
        }
        .navigationDestination(isPresented: $navigateToLocation) {
            SessionLocationView()
        }
    }
    
    // MARK: - Subviews
    
    private var statusBadge: some View {
        Text(viewModel.session.status.badgeText)
            .font(.system(size: 13, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 22)
            .padding(.vertical, 10)
            .background(Color(red: 0.18, green: 0.80, blue: 0.44))
            .cornerRadius(20)
            .shadow(color: Color(red: 0.18, green: 0.80, blue: 0.44).opacity(0.35), radius: 6, x: 0, y: 3)
    }
    
    private var subjectDetailsCard: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Text("SUBJECT : \(viewModel.session.subjectName)")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                
                Divider()
                    .padding(.horizontal, 8)
            }
            
            // Teacher & Learner Profiles with CustomAvatarImage
            HStack(spacing: 20) {
                // Teacher Profile
                VStack(spacing: 8) {
                    CustomAvatarImage(
                        imageName: viewModel.session.teacherAvatarUrl ?? "TutorNuvi",
                        size: 80
                    )
                    
                    Text("TEACHER")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.session.teacherName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                
                // Learner Profile
                VStack(spacing: 8) {
                    CustomAvatarImage(
                        imageName: viewModel.session.learnerAvatarUrl ?? "TutorShenali",
                        size: 80
                    )
                    
                    Text("LEARNER")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.session.learnerName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
            }
            
            // Date & Time Summary Card
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Date")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    
                    Text(viewModel.session.dateString)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Time")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    
                    Text(viewModel.session.timeString)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
            .background(Color(red: 0.95, green: 0.95, blue: 0.96))
            .cornerRadius(14)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(22)
        .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 2)
    }
    
    private var locationCard: some View {
        Button(action: { navigateToLocation = true }) {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.22, green: 0.30, blue: 0.72).opacity(0.12))
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("MEETING LOCATION")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    
                    Text(viewModel.session.locationName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray.opacity(0.6))
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(18)
            .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button(action: { navigateToActiveSession = true }) {
                Text("Start Session")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 0.25, green: 0.32, blue: 0.72))
                    .cornerRadius(27)
                    .shadow(color: Color(red: 0.25, green: 0.32, blue: 0.72).opacity(0.35), radius: 8, x: 0, y: 4)
            }
            
            Button(action: { navigateToChat = true }) {
                Text("Open Chat")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.white)
                    .cornerRadius(27)
                    .overlay(
                        RoundedRectangle(cornerRadius: 27)
                            .stroke(Color(red: 0.22, green: 0.30, blue: 0.72), lineWidth: 2)
                    )
            }
            .padding(.top, 4)
            
            Button(action: { viewModel.showCancelAlert = true }) {
                Text("Cancel Session")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.red)
                    .underline()
            }
            .padding(.top, 8)
        }
        .padding(.top, 10)
    }
}
