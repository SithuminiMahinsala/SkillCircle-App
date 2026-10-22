//
//  ProposeSessionView.swift
//  SkillCircle
//

import SwiftUI
import MapKit

struct ProposeSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ProposeSessionViewModel
    var onProposalSent: (() -> Void)?
    
    init(subjectName: String = "STATISTICS", chatId: String = "", onProposalSent: (() -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: ProposeSessionViewModel(subjectName: subjectName, chatId: chatId))
        self.onProposalSent = onProposalSent
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    
                    // MARK: 1. Goal Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("WHAT IS THE GOAL OF THIS SESSION?")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        
                        ForEach(SessionGoal.allCases) { goalOption in
                            Button(action: { viewModel.form.goal = goalOption }) {
                                HStack {
                                    Text(goalOption.rawValue)
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor(viewModel.form.goal == goalOption ? Color(red: 0.22, green: 0.30, blue: 0.72) : Color.gray.opacity(0.8))
                                    
                                    Spacer()
                                    
                                    Image(systemName: viewModel.form.goal == goalOption ? "largecircle.fill.circle" : "circle")
                                        .font(.system(size: 22))
                                        .foregroundColor(viewModel.form.goal == goalOption ? Color(red: 0.22, green: 0.30, blue: 0.72) : Color.gray.opacity(0.4))
                                }
                                .padding(.horizontal, 16)
                                .frame(height: 54)
                                .background(viewModel.form.goal == goalOption ? Color.white : Color(red: 0.91, green: 0.92, blue: 0.94))
                                .cornerRadius(16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(viewModel.form.goal == goalOption ? Color(red: 0.22, green: 0.30, blue: 0.72).opacity(0.15) : Color.clear, lineWidth: 1)
                                )
                                .shadow(color: viewModel.form.goal == goalOption ? .black.opacity(0.04) : .clear, radius: 4, x: 0, y: 2)
                            }
                        }
                    }
                    
                    // MARK: 2. Subject Name Card
                    VStack(alignment: .leading, spacing: 6) {
                        Text("SUBJECT NAME")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        
                        Text(viewModel.form.subjectName)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(18)
                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    
                    // MARK: 3. Schedule Details
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SCHEDULE DETAILS")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        
                        // Select Date Picker
                        HStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 20))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            
                            Text("Select Date")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            Spacer()
                            
                            DatePicker("", selection: $viewModel.form.selectedDate, displayedComponents: .date)
                                .labelsHidden()
                                .tint(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 54)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                        
                        // Start & End Time Fields
                        HStack(spacing: 12) {
                            // Start Time
                            VStack(alignment: .leading, spacing: 4) {
                                Text("START TIME")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    DatePicker("", selection: $viewModel.form.startTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                            
                            // End Time
                            VStack(alignment: .leading, spacing: 4) {
                                Text("END TIME")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    DatePicker("", selection: $viewModel.form.endTime, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                    Spacer()
                                    Image(systemName: "calendar")
                                        .font(.system(size: 16))
                                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                }
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(16)
                            .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    // MARK: 4. Select Method
                    VStack(alignment: .leading, spacing: 12) {
                        Text("SELECT METHOD")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        
                        HStack(spacing: 12) {
                            ForEach(SessionMethod.allCases) { methodOption in
                                Button(action: { viewModel.form.method = methodOption }) {
                                    HStack {
                                        Image(systemName: viewModel.form.method == methodOption ? "largecircle.fill.circle" : "circle")
                                            .font(.system(size: 18))
                                            .foregroundColor(viewModel.form.method == methodOption ? Color(red: 0.22, green: 0.30, blue: 0.72) : Color.gray.opacity(0.4))
                                        
                                        Text(methodOption.rawValue)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(viewModel.form.method == methodOption ? Color(red: 0.22, green: 0.30, blue: 0.72) : Color.gray.opacity(0.7))
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(viewModel.form.method == methodOption ? Color.white : Color(red: 0.91, green: 0.92, blue: 0.94))
                                    .cornerRadius(14)
                                    .shadow(color: viewModel.form.method == methodOption ? .black.opacity(0.04) : .clear, radius: 4, x: 0, y: 2)
                                }
                            }
                        }
                    }
                    
                    // MARK: 5. Method Specific Inputs
                    if viewModel.form.method == .physical {
                        // Physical Sub-Location Switcher
                        HStack(spacing: 8) {
                            ForEach(PhysicalLocationType.allCases) { locType in
                                Button(action: { viewModel.form.physicalLocationType = locType }) {
                                    Text(locType.rawValue)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(viewModel.form.physicalLocationType == locType ? .white : Color.gray.opacity(0.8))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 44)
                                        .background(viewModel.form.physicalLocationType == locType ? Color(red: 0.25, green: 0.32, blue: 0.72) : Color(red: 0.90, green: 0.90, blue: 0.92))
                                        .cornerRadius(12)
                                }
                            }
                        }
                        
                        if viewModel.form.physicalLocationType == .indoor {
                            // Indoor Form Fields
                            VStack(spacing: 12) {
                                HStack(spacing: 12) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("BUILDING")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.gray)
                                        TextField("Building", text: $viewModel.form.building)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("FLOOR")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(.gray)
                                        TextField("Floor", text: $viewModel.form.floor)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                    }
                                    .padding(12)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .cornerRadius(14)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("ROOM")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.gray)
                                    TextField("Room", text: $viewModel.form.room)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white)
                                .cornerRadius(14)
                            }
                        } else {
                            // Pin On Map MapKit Box
                            Map(position: $viewModel.mapCameraPosition) {
                                Annotation("", coordinate: CLLocationCoordinate2D(latitude: viewModel.form.latitude, longitude: viewModel.form.longitude)) {
                                    ZStack {
                                        Circle()
                                            .fill(Color(red: 0.22, green: 0.30, blue: 0.72).opacity(0.3))
                                            .frame(width: 54, height: 54)
                                        
                                        Image(systemName: "mappin.circle.fill")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                    }
                                }
                            }
                            .frame(height: 180)
                            .cornerRadius(20)
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        }
                    } else {
                        // Online Meeting Link Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("ONLINE MEETING LINK")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            TextField("PASTE YOUR LINK", text: $viewModel.form.meetingLink)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(16)
                                .shadow(color: .black.opacity(0.03), radius: 4, x: 0, y: 2)
                        }
                    }
                    
                    Divider()
                        .padding(.vertical, 4)
                    
                    // MARK: 6. Estimated Earnings Banner
                    HStack {
                        Text("ESTIMATED EARNINGS : \(viewModel.form.estimatedTokens) KNOWLEDGE TOKEN")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(Color(red: 0.45, green: 0.32, blue: 0.05))
                        
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.18))
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .background(Color(red: 0.97, green: 0.94, blue: 0.88))
                    .cornerRadius(14)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(red: 0.90, green: 0.82, blue: 0.68), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            
            // MARK: 7. Fixed Bottom "Send Proposal" Button
            VStack {
                Button(action: {
                    viewModel.submitProposal {
                        onProposalSent?()
                        dismiss()
                    }
                }) {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Send Proposal")
                                .font(.system(size: 17, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color(red: 0.25, green: 0.32, blue: 0.72))
                    .cornerRadius(27)
                    .shadow(color: Color(red: 0.25, green: 0.32, blue: 0.72).opacity(0.35), radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.isSubmitting)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
            }
            .background(Color.white.shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: -4))
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationTitle("PROPOSE A SESSION")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProposeSessionView()
    }
}
