import SwiftUI

struct SessionSuccessView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = SessionSuccessViewModel()
    
    var onReturnHome: (() -> Void)?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 1. Success Icon & Heading
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.22, green: 0.78, blue: 0.40))
                            .frame(width: 80, height: 80)
                            .shadow(color: Color.green.opacity(0.3), radius: 10, x: 0, y: 5)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                    }
                    
                    Text("SESSION COMPLETED")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.78, blue: 0.40))
                }
                .padding(.top, 8)
                
                // 2. Session Summary Card
                HStack(spacing: 0) {
                    // Left Accent Line
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .frame(width: 6)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Subject Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SUBJECT NAME")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.65))
                            Text(viewModel.summary.subjectName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        }
                        
                        // Teacher Name
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TEACHER NAME")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.65))
                            Text(viewModel.summary.teacherName)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 4) {
                            Text("DURATION")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.65))
                            Text("\(viewModel.summary.durationMinutes) MIN")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        }
                        
                        // Tokens
                        VStack(alignment: .leading, spacing: 4) {
                            Text("TOKENS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.65))
                            Text(String(format: "%.1f TOKEN", viewModel.summary.tokensEarned))
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                        }
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 16)
                    
                    Spacer()
                }
                .background(Color(red: 0.96, green: 0.97, blue: 0.99))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.12), lineWidth: 1)
                )
                
                // 3. Star Rating Section
                VStack(spacing: 8) {
                    HStack(spacing: 12) {
                        ForEach(1...5, id: \.self) { index in
                            Image(systemName: index <= viewModel.rating ? "star.fill" : "star")
                                .font(.system(size: 32))
                                .foregroundColor(Color(red: 1.0, green: 0.76, blue: 0.18))
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                                        viewModel.rating = index
                                    }
                                }
                        }
                    }
                    
                    Text("RATE YOUR EXPERIENCE")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(Color(red: 0.45, green: 0.50, blue: 0.65))
                        .padding(.top, 4)
                }
                .padding(.top, 6)
                
                // 4. Feedback Text Area
                VStack(alignment: .trailing, spacing: 4) {
                    ZStack(alignment: .topLeading) {
                        if viewModel.feedbackText.isEmpty {
                            Text("Write your feedback here...")
                                .font(.system(size: 14))
                                .foregroundColor(.gray.opacity(0.7))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                        }
                        
                        TextEditor(text: $viewModel.feedbackText)
                            .font(.system(size: 14))
                            .frame(height: 120)
                            .padding(8)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                    }
                    .background(Color(red: 0.94, green: 0.94, blue: 0.96))
                    .cornerRadius(16)
                    
                    Text("\(viewModel.feedbackText.count)/\(viewModel.maxCharacterCount)")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(red: 0.35, green: 0.45, blue: 0.72))
                        .padding(.trailing, 4)
                }
                
                // 5. Bonus Tip Checkbox
                Button(action: { viewModel.isBonusTipApplied.toggle() }) {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: viewModel.isBonusTipApplied ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        
                        Text("This Tutor Was Exceptionally Helpful ( +0.5 Bonus Tip )")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color(red: 0.25, green: 0.35, blue: 0.65))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, 4)
                
                // 6. Rate & Submit Button
                Button(action: {
                    viewModel.submitFeedback {
                        if let onReturnHome = onReturnHome {
                            onReturnHome()
                        } else {
                            dismiss()
                        }
                    }
                }) {
                    HStack {
                        if viewModel.isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Rate & Submit")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(viewModel.rating > 0 ? Color(red: 0.22, green: 0.30, blue: 0.72) : Color.gray.opacity(0.5))
                    .cornerRadius(26)
                    .shadow(color: viewModel.rating > 0 ? Color(red: 0.22, green: 0.30, blue: 0.72).opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
                }
                .disabled(viewModel.rating == 0 || viewModel.isSubmitting)
                .padding(.top, 4)
                
                // 7. Back To Home Link Button
                Button(action: {
                    if let onReturnHome = onReturnHome {
                        onReturnHome()
                    } else {
                        dismiss()
                    }
                }) {
                    Text("BACK TO HOME")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .underline()
                }
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white.ignoresSafeArea())
        .navigationTitle("SESSION SUCCESS")
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