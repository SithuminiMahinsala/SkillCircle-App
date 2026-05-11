//
//  OnboardingEarnView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct OnboardingEarnView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            
            HStack {
                HStack(spacing: 8) {
                    Image("AppLogoSmall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                    
                    Text("SkillCircle")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.deepIndigo)
                }
                Spacer()
                
                Button(action: {
                   
                }) {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .foregroundColor(.deepIndigo)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 10)

            Spacer()

            
            ZStack(alignment: .bottom) {
               
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 15, x: 0, y: 10)
                    .frame(height: 340)
                
               
                Image("TutorWorkingImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 280, height: 260)
                    .clipped()
                    .padding(.bottom, 40)

              
                
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 24)
                .background(Color.white)
                .cornerRadius(8)
                .offset(y: 20)
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)

          
            VStack(spacing: 16) {
                Text("EARN KNOWLEDGE TOKENS")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text("Share your expertise in subjects you master and get rewarded with valuable tokens.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }

            Spacer()
            
           
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
                
                Circle()
                    .fill(Color.deepIndigo)
                    .frame(width: 10, height: 10)
                
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
            .padding(.vertical, 10)

            Spacer()

           
            Button(action: {
                // Navigate to the third onboarding screen
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.deepIndigo)
                            .shadow(color: Color.deepIndigo.opacity(0.3), radius: 10, x: 0, y: 5)
                    )
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    OnboardingEarnView()
}
