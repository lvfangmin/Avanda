import SwiftUI
import WebKit

struct YouTubeRewardView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedVideo: YouTubeVideo?
    @State private var isLoading = true
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🎉 Amazing! You've earned a fun video! 🎉")
                .font(.title2.bold())
                .foregroundColor(.purple)
                .multilineTextAlignment(.center)
                .padding()
            
            if isLoading {
                ProgressView("Loading your reward...")
            } else if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
            } else if let video = selectedVideo {
                WebViewWrapper(urlString: "https://www.youtube.com/embed/\(video.id)?autoplay=1")
                    .frame(height: 300)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
                
                Text(video.title)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            Button("Back to Learning") {
                dismiss()
            }
            .font(.title3.bold())
            .foregroundColor(.white)
            .frame(width: 200, height: 50)
            .background(Color.purple)
            .cornerRadius(25)
        }
        .padding()
        .frame(minWidth: 600, minHeight: 400)
        .onAppear {
            loadRandomVideo()
        }
    }
    
    private func loadRandomVideo() {
        YouTubeService.shared.fetchEducationalVideos { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let videos):
                    selectedVideo = videos.randomElement()
                case .failure(let error):
                    errorMessage = "Failed to load video: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    YouTubeRewardView()
} 