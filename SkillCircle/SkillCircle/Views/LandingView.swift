//
//  LandingView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-05-11.
//

import SwiftUI

struct LandingView: View {
    var body: some View {
        NavigationStack {
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
                    
                
                    NavigationLink(destination: Text("Login Screen Coming Soon")) {
                        Text("Sign in")
                            .fontWeight(.semibold)
                            .foregroundColor(.deepIndigo)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)

                Spacer()

                
                Image("MainHeroIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .padding(.bottom, 20)

                
                VStack(spacing: 16) {
                    Text("Trade Your Skills,\nNot Your Money")
                        .font(.system(size: 34, weight: .black))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.primary)

                    Text("The exclusive peer-to-peer knowledge exchange for university students. Earn tokens by teaching others and spend them to learn something new.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 35)
                        .lineSpacing(4)
                }

                Spacer()

                
                VStack(spacing: 20) {
                  
                    NavigationLink(destination: Text("Onboarding Coming Soon")) {
                        Text("Get Started")
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

                    HStack(spacing: 4) {
                        Text("ALREADY A USER?")
                            .font(.caption)
                            .tracking(0.5)
                            .foregroundColor(.secondary)
                        
                        NavigationLink(destination: Text("Login Screen Coming Soon")) {
                            Text("SIGN IN")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.deepIndigo)
                                .underline()
                        }
                    }
                }

                Spacer()

                
                HStack(spacing: 30) {
                    Text("PRIVACY")
                    Text("TERMS")
                    Text("CONTACT")
                }
                .font(.caption2)
                .foregroundColor(.secondary.opacity(0.8))
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    LandingView()
}
