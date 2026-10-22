//
//  ActiveSessionTeacherView.swift
//  SkillCircle
//

import SwiftUI

struct ActiveSessionTeacherView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ActiveSessionViewModel()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // 1. Subject & Learner Info Card
                HStack(spacing: 0) {
                    // Left Accent Stripe
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .frame(width: 6)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SUBJECT NAME")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.35, green: 0.40, blue: 0.65))
                            
                            Text(viewModel.session.subjectName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                        
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LEARNER NAME")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color(red: 0.35, green: 0.40, blue: 0.65))
                            
                            Text(viewModel.session.learnerName)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 16)
                    
                    Spacer()
                }
                .background(Color(red: 0.93, green: 0.94, blue: 0.98))
                .cornerRadius(16)
                
                // 2. Study Timer Card
                VStack(spacing: 16) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.88, green: 0.93, blue: 1.0))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "timer")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        }
                        
                        Text("STUDY TIMER")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black)
                    }
                    
                    Text(viewModel.formattedTime)
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 10, height: 10)
                        
                        Text(viewModel.session.status.rawValue)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.green)
                    }
                }
                .padding(.vertical, 24)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                
                // 3. QR Code Card
                VStack {
                    QRCodeView(payload: viewModel.session.qrCodePayload)
                        .padding(24)
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
                .background(Color.white)
                .cornerRadius(28)
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                
                // 4. Instructions
                Text("SHOW THIS CODE TO THE LEARNER TO START THE SESSION")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 24)
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationTitle("ACTIVE SESSION")
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
