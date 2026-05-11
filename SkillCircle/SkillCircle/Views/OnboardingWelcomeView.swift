//
//  OnboardingWelcomeView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct OnboardingWelcomeView: View {
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

            
            Image("OnboardingWelcomeImage")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 280)
                .padding(.bottom, 20)

           
            VStack(spacing: 16) {
                Text("WELCOME TO SKILLCIRCLE")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text("Connect with university peers to learn and grow together.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }

            Spacer()
            
           
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.deepIndigo)
                    .frame(width: 10, height: 10)
                
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
                
                Circle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
            .padding(.vertical, 10)

            Spacer()

            
            Button(action: {
                
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
    OnboardingWelcomeView()
}
