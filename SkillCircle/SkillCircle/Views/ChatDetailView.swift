import SwiftUI

struct ChatDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ChatDetailViewModel
    @State private var showProposeSessionSheet: Bool = false
    
    init(partnerName: String = "SHENALI", subjectName: String = "STATISTICS", isTeacherView: Bool = false) {
        _viewModel = StateObject(wrappedValue: ChatDetailViewModel(
            partnerName: partnerName,
            subjectName: subjectName,
            isTeacherView: isTeacherView
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: 1. Message Stream Area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            ChatMessageBubble(
                                message: message,
                                isTeacherView: viewModel.isTeacherView,
                                onConfirmProposal: {
                                    if let propId = message.proposal?.id {
                                        viewModel.confirmProposal(proposalId: propId)
                                    }
                                }
                            )
                            .id(message.id)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 16)
                }
            }
            
            // MARK: 2. Propose New Session Action Button
            Button(action: { showProposeSessionSheet = true }) {
                Text("+ Propose New Session")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color(red: 0.22, green: 0.30, blue: 0.72), lineWidth: 2)
                    )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            
            // MARK: 3. Message Input Bar
            HStack(spacing: 12) {
                TextField("Type A Message...", text: $viewModel.typedMessage)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .background(Color(red: 0.92, green: 0.93, blue: 0.95))
                    .cornerRadius(24)
                
                Button(action: { viewModel.sendMessage() }) {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.25, green: 0.32, blue: 0.72))
                            .frame(width: 48, height: 48)
                        
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            .padding(.top, 4)
            .background(Color.white)
        }
        .background(Color(red: 0.95, green: 0.96, blue: 0.98).ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                HStack(spacing: 10) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "arrow.left.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    }
                    
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundColor(.gray.opacity(0.8))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(viewModel.partnerName)-")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                        Text(viewModel.subjectName)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                }
            }
        }
        
        .sheet(isPresented: $showProposeSessionSheet) {
            NavigationStack {
                ProposeSessionView(
                    subjectName: viewModel.subjectName,
                    onProposalSent: {
                        viewModel.loadMessages()
                    }
                )
            }
        }
    }
}
