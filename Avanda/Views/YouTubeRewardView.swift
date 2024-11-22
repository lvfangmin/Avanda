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
                VideoPlayer(videoID: video.id)
                    .frame(height: 300)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.purple.opacity(0.3), lineWidth: 1)
                    )
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
                    selectedVideo = videos.first
                case .failure(let error):
                    errorMessage = "Failed to load video: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct VideoPlayer: NSViewRepresentable {
    let videoID: String
    
    func makeNSView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        loadVideo(in: webView)
        return webView
    }
    
    func updateNSView(_ webView: WKWebView, context: Context) {
        loadVideo(in: webView)
    }
    
    private func loadVideo(in webView: WKWebView) {
        let embedHTML = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style>
                    body, html { margin: 0; padding: 0; width: 100%; height: 100%; }
                    .video-container { position: relative; padding-bottom: 56.25%; height: 0; }
                    .video-container iframe {
                        position: absolute;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        border: 0;
                    }
                </style>
            </head>
            <body>
                <div class="video-container">
                    <iframe
                        src="https://www.youtube.com/embed/\(videoID)?enablejsapi=1&autoplay=1&playsinline=1"
                        frameborder="0"
                        allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                        allowfullscreen>
                    </iframe>
                </div>
            </body>
            </html>
        """
        
        webView.loadHTMLString(embedHTML, baseURL: nil)
    }
}

#Preview {
    YouTubeRewardView()
} 