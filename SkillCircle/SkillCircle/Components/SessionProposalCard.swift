import SwiftUI

struct SessionProposalCard: View {
    let proposal: SessionProposal
    let isTeacherView: Bool
    var onConfirmProposal: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            // Header
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(red: 0.98, green: 0.88, blue: 0.55))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: "academiccap.fill")
                        .font(.system(size: 16))
                        .foregroundColor(Color(red: 0.85, green: 0.60, blue: 0.10))
                }
                
                Text("PROPOSED SESSION")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                
                Spacer()
                
                Text(proposal.sessionId)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            
            // Date Row
            HStack(spacing: 12) {
                Image(systemName: "calendar")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("DATE")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    Text(proposal.dateText)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                }
            }
            
            // Time Row
            HStack(spacing: 12) {
                Image(systemName: "timer")
                    .font(.system(size: 20))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("TIME")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.gray)
                    Text(proposal.timeRange)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                }
            }
            
            // Location & Method Row
            HStack(alignment: .top, spacing: 16) {
                HStack(spacing: 10) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("LOCATION")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        Text(proposal.location)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    }
                }
                
                Spacer()
                
                HStack(spacing: 10) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("METHOD")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.gray)
                        Text(proposal.method)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                    }
                }
            }
            
            // Action Button
            if isTeacherView {
                Button(action: {}) {
                    Text(proposal.status.rawValue)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color(red: 0.25, green: 0.32, blue: 0.72))
                        .cornerRadius(24)
                }
                .disabled(true)
            } else {
                Button(action: { onConfirmProposal?() }) {
                    Text(proposal.status == .confirmed ? "Confirmed" : "Confirm")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(proposal.status == .confirmed ? Color.green : Color(red: 0.25, green: 0.32, blue: 0.72))
                        .cornerRadius(24)
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .cornerRadius(24)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
    }
}