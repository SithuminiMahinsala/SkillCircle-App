import SwiftUI

struct ChatMessageBubble: View {
    let message: ChatMessage
    let isTeacherView: Bool
    var onConfirmProposal: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 8) {
            // Optional Date Header Pill
            if let dateHeader = message.dateHeader {
                Text(dateHeader)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Color.white)
                    .cornerRadius(12)
                    .padding(.vertical, 8)
            }
            
            if let proposal = message.proposal {
                // Proposal Card Embed
                SessionProposalCard(
                    proposal: proposal,
                    isTeacherView: isTeacherView,
                    onConfirmProposal: onConfirmProposal
                )
                .padding(.horizontal, 12)
            } else if let text = message.textMessage {
                // Regular Text Message Bubble
                VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
                    Text(message.senderName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                    
                    HStack(alignment: .bottom, spacing: 8) {
                        if !message.isFromCurrentUser {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                        
                        Text(text)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(message.isFromCurrentUser ? Color(red: 0.12, green: 0.15, blue: 0.25) : Color(red: 0.12, green: 0.15, blue: 0.25))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .cornerRadius(18)
                            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
                        
                        if message.isFromCurrentUser {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.gray.opacity(0.6))
                        }
                    }
                    
                    Text(message.timestamp)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                        .padding(.horizontal, 4)
                }
                .frame(maxWidth: .infinity, alignment: message.isFromCurrentUser ? .trailing : .leading)
            }
        }
    }
}