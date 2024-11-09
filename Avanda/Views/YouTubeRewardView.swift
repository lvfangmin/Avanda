import SwiftUI
import AVKit

struct YouTubeRewardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var player: AVPlayer?
    
    // Sample video from a public source
    let videoURL = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Amazing! You've earned a break! 🎉")
                .font(.title2.bold())
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
                .padding()
            
            if let player = player {
                VideoPlayer(player: player)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
                    .aspectRatio(16/9, contentMode: .fit)
                    .allowsHitTesting(true) // Enable user interaction
            } else {
                ProgressView("Loading video...")
                    .frame(height: 300)
            }
            
            Button("Back to Learning") {
                player?.pause()
                dismiss()
            }
            .font(.title3.bold())
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.purple)
            .cornerRadius(25)
        }
        .padding()
        .frame(minWidth: 800, minHeight: 600)
        .onAppear {
            if let url = videoURL {
                let playerItem = AVPlayerItem(url: url)
                player = AVPlayer(playerItem: playerItem)
                
                // Enable full-screen support
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: playerItem,
                    queue: .main
                ) { _ in
                    player?.seek(to: .zero)
                    player?.play()
                }
                
                player?.play()
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

#Preview {
    YouTubeRewardView()
} 