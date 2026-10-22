//
//  TokenTrendsView.swift
//  SkillCircle
//
//  Created by COBSCCOMP242P-001 on 2026-10-22.
//

import SwiftUI

struct TokenTrendsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRange: String = "1W"
    
    private let ranges = ["1W", "1M", "3M", "6M", "1Y"]
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.96, blue: 0.98)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // MARK: 1. Time Range Selector Segment
                    HStack(spacing: 0) {
                        ForEach(ranges, id: \.self) { range in
                            Button(action: { selectedRange = range }) {
                                Text(range)
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(selectedRange == range ? .white : Color.gray.opacity(0.8))
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 36)
                                    .background(selectedRange == range ? Color(red: 0.25, green: 0.32, blue: 0.72) : Color.clear)
                                    .cornerRadius(18)
                            }
                        }
                    }
                    .padding(4)
                    .background(Color.white.opacity(0.6))
                    .cornerRadius(22)
                    
                    // MARK: 2. Token Graph Card
                    VStack(alignment: .leading, spacing: 16) {
                        ZStack(alignment: .bottom) {
                            // Y-Axis Grid Lines & Labels
                            VStack(alignment: .leading) {
                                ForEach([20, 15, 10, 5, 0], id: \.self) { val in
                                    HStack {
                                        Text("\(val)")
                                            .font(.system(size: 11))
                                            .foregroundColor(.gray.opacity(0.8))
                                            .frame(width: 20, alignment: .leading)
                                        
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.12))
                                            .frame(height: 1)
                                    }
                                    if val > 0 { Spacer() }
                                }
                            }
                            .frame(height: 180)
                            
                            // Line Graph & Gradient Area
                            GeometryReader { geometry in
                                let points: [CGPoint] = [
                                    CGPoint(x: 25, y: 110),
                                    CGPoint(x: 100, y: 125),
                                    CGPoint(x: 175, y: 85),
                                    CGPoint(x: 250, y: 55),
                                    CGPoint(x: 310, y: 40)
                                ]
                                
                                ZStack {
                                    // Gradient Fill
                                    Path { path in
                                        path.move(to: CGPoint(x: points[0].x, y: 180))
                                        path.addLine(to: points[0])
                                        for i in 1..<points.count {
                                            path.addLine(to: points[i])
                                        }
                                        path.addLine(to: CGPoint(x: points.last!.x, y: 180))
                                        path.closeSubpath()
                                    }
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.yellow.opacity(0.35), Color.yellow.opacity(0.01)]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    
                                    // Smooth Curve Line
                                    Path { path in
                                        path.move(to: points[0])
                                        for i in 1..<points.count {
                                            path.addLine(to: points[i])
                                        }
                                    }
                                    .stroke(Color(red: 0.95, green: 0.75, blue: 0.18), lineWidth: 3)
                                    
                                    // End Point Indicator Dot
                                    Circle()
                                        .fill(Color(red: 0.95, green: 0.75, blue: 0.18))
                                        .frame(width: 8, height: 8)
                                        .position(points.last!)
                                }
                            }
                            .frame(height: 180)
                        }
                        
                        // X-Axis Labels
                        HStack {
                            Text("Mar 10")
                            Spacer()
                            Text("Mar 17")
                            Spacer()
                            Text("Mar 24")
                            Spacer()
                            Text("Apr 01")
                                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                                .bold()
                        }
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                        .padding(.leading, 24)
                    }
                    .padding(20)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    
                    // MARK: 3. Net Gain Card
                    VStack(alignment: .leading, spacing: 6) {
                        Text("NET GAIN (1 MONTH)")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 8) {
                            Text("+5.0")
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(Color(red: 0.20, green: 0.70, blue: 0.35))
                            
                            Image(systemName: "star.fill")
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.95, green: 0.75, blue: 0.18))
                        }
                        
                        Text("Calculated from earnings & spending.")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    
                    // MARK: 4. High/Low Balance Grid Cards
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("HIGHEST\nBALANCE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                            
                            Text("19.5")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            Text("Reached Mar 28")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("LOWEST\nBALANCE")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundColor(.gray)
                            
                            Text("12.0")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            Text("Reached Mar 15")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(18)
                        .shadow(color: .black.opacity(0.03), radius: 6, x: 0, y: 2)
                    }
                    
                    // MARK: 5. Knowledge Economy Insights Banner
                    HStack(alignment: .top, spacing: 14) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.95, green: 0.75, blue: 0.18))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "academiccap.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("KNOWLEDGE ECONOMY\nINSIGHTS")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                            
                            (
                                Text(.init("Your token balance has grown by **[40%]()** this month! You are earning most of your tokens on **Tuesdays** through Math tutoring."))
                                    .font(.system(size: 13))
                                    .foregroundColor(.gray)
                                    .tint(Color(red: 0.22, green: 0.30, blue: 0.72))
                                    .lineSpacing(2)
                            )
                            .font(.system(size: 13))
                            .lineSpacing(2)
                        }
                    }
                    .padding(18)
                    .background(Color(red: 0.89, green: 0.90, blue: 0.96))
                    .cornerRadius(20)
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
                Text("TOKEN TRENDS")
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
    }
}
