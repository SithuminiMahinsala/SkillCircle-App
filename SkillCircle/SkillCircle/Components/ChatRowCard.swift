import SwiftUI

struct ChatRowCard: View {
    let conversation: ChatConversation
    
    var body: some View {
        HStack(spacing: 14) {
            // Avatar Placeholder
            ZStack {
                Circle()
                    .fill(Color(red: 0.90, green: 0.92, blue: 0.96))
                    .frame(width: 54, height: 54)
                
                Image(systemName: conversation.userAvatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
            }
            
            // Conversation Info
            VStack(alignment: .leading, spacing: 4) {
                Text(conversation.userName)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.12, green: 0.15, blue: 0.25))
                
                Text(conversation.subjectTag)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                
                Text(conversation.lastMessage)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // Timestamp & Unread Dot
            VStack(alignment: .trailing, spacing: 12) {
                Text(conversation.timestamp)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.gray.opacity(0.8))
                
                if conversation.hasUnreadMessage {
                    Circle()
                        .fill(Color(red: 0.22, green: 0.30, blue: 0.72))
                        .frame(width: 10, height: 10)
                } else {
                    Spacer()
                        .frame(height: 10)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
    }
}