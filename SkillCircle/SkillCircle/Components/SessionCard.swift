//
//  SessionCard.swift
//  SkillCircle
//

import SwiftUI
import UIKit

// MARK: - Avatar (photo if the asset exists, otherwise initials)
struct SessionAvatarView: View {
    let name: String
    let imageName: String?
    var size: CGFloat = 48

    private var initials: String {
        name.split(separator: " ").prefix(2).compactMap { $0.first }.map(String.init).joined()
    }

    var body: some View {
        Group {
            if let imageName, UIImage(named: imageName) != nil {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.deepIndigo.opacity(0.15)
                    Text(initials)
                        .font(.system(size: size * 0.36, weight: .bold))
                        .foregroundColor(.deepIndigo)
                }
            }
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}

// MARK: - Card
struct SessionCard: View {
    let session: TutoringSession

    private static let dayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM"
        return f
    }()

    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h.mm a"
        return f
    }()

    private var buttonTitle: String {
        session.status == .requests ? "Review Request" : "View Details"
    }

    var body: some View {
        VStack(spacing: 12) {

            // Title + date
            HStack(alignment: .top) {
                Text(session.subject.uppercased())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                VStack(alignment: .trailing, spacing: 2) {
                    Text(Self.dayFormatter.string(from: session.date))
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.sessionAccentBlue)
                    Text(Self.timeFormatter.string(from: session.date))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 10)

            // Tutor + location
            VStack(spacing: 10) {
                HStack(spacing: 12) {
                    SessionAvatarView(name: session.tutorName, imageName: session.tutorImageName)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(session.tutorName.uppercased())
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        HStack(spacing: 6) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.deepIndigo)
                            Text(session.location)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal, 10)

                Divider()
                    .padding(.horizontal, 10)
            }

            // Action button
            NavigationLink(destination: SessionDetailView()) {
                Text(buttonTitle)
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule()
                            .fill(Color.deepIndigo)
                            .shadow(color: Color.deepIndigo.opacity(0.3), radius: 8, x: 0, y: 5)
                    )
            }
        }
        .padding(10)
        .padding(.top, 4)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 14, x: 0, y: 8)
    }
}

#Preview {
    NavigationStack {
        SessionCard(session: MockData.sessions[0])
            .padding()
            .background(Color.sessionBackground)
    }
}
