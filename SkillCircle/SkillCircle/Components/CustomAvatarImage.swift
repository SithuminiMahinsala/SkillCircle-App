//
//  CustomAvatarImage.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import SwiftUI

struct CustomAvatarImage: View {
    let imageName: String?
    let size: CGFloat
    let fallbackSymbol: String
    
    init(imageName: String?, size: CGFloat = 60, fallbackSymbol: String = "person.crop.circle.fill") {
        self.imageName = imageName
        self.size = size
        self.fallbackSymbol = fallbackSymbol
    }
    
    var body: some View {
        if let name = imageName, !name.isEmpty, UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        } else {
            ZStack {
                Circle()
                    .fill(Color(red: 0.90, green: 0.92, blue: 0.96))
                    .frame(width: size, height: size)
                
                Image(systemName: fallbackSymbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: size * 0.6, height: size * 0.6)
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
    }
}
