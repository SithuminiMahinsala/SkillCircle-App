import SwiftUI
import AVFoundation

struct QRScannerView: View {
    var onFrameScanned: (String) -> Void
    
    var body: some View {
        ZStack {
            // Camera Preview / Placeholder Area
            Color.gray.opacity(0.2)
            
            // Background grid pattern simulation
            Image(systemName: "qrcode")
                .resizable()
                .scaledToFit()
                .padding(60)
                .opacity(0.15)
            
            // "QR SCANNER" Overlay Badge
            Text("QR SCANNER")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(Color(red: 0.22, green: 0.30, blue: 0.72))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color(red: 0.78, green: 0.82, blue: 0.95).opacity(0.85))
                .cornerRadius(20)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // Simulated scan trigger for testing on Xcode Simulator
            onFrameScanned("skillcircle://session/SES-1029/verify")
        }
    }
}