//
//  ActiveSessionLearnerView.swift
//  SkillCircle
//

import SwiftUI

struct ActiveSessionLearnerView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ActiveSessionLearnerViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // 1. Subject & Learner/Teacher Info Header
                    HStack(spacing: 0) {
                        // Left Blue Accent Stripe
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                            .frame(width: 6)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("SUBJECT NAME")
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(Color(red: 0.35, green: 0.40, blue: 0.65))
                                
                                Text(viewModel.session.subjectName)
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            }
                            
                            Divider()
                                .background(Color.gray.opacity(0.25))
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("LEARNER NAME")
                                    .font(.system(size: 11, weight: .semibold))
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
                    
                    // 2. Camera Scanner Box Card
                    VStack(spacing: 16) {
                        QRScannerView { scannedPayload in
                            viewModel.verifyQRCode(scannedPayload)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .cornerRadius(20)
                        .clipped()
                        
                        Text("SCAN THE TEACHER'S QR CODE TO START\nTHE STUDY TIMER")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.bottom, 8)
                    }
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                    
                    // 3. Study Timer Box
                    VStack(spacing: 12) {
                        HStack(spacing: 8) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.88, green: 0.93, blue: 1.0))
                                    .frame(width: 36, height: 36)
                                
                                Image(systemName: "timer")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                            }
                            
                            Text("STUDY TIMER")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.black)
                        }
                        
                        Text(viewModel.formattedTime)
                            .font(.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        
                        HStack(spacing: 6) {
                            Circle()
                                .fill(viewModel.session.status == .active ? Color.green : Color.orange)
                                .frame(width: 8, height: 8)
                            
                            Text(viewModel.session.status.rawValue)
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(viewModel.session.status == .active ? .green : .orange)
                        }
                    }
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(24)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
                    
                    // 4. Token Escrow Warning Label
                    Text("1 TOKEN WILL BE LOCKED UPON\nSUCCESSFUL SCAN")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color(red: 0.20, green: 0.60, blue: 0.95))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 20)
            }
            
            // 5. Fixed End Session Action Button
            Button(action: {
                viewModel.endSession()
                dismiss()
            }) {
                Text("End Session")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color(red: 0.98, green: 0.28, blue: 0.22))
                    .cornerRadius(28)
                    .shadow(color: Color.red.opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
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
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Verification Failed"),
                message: Text(viewModel.alertMessage ?? "Scan Error"),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
