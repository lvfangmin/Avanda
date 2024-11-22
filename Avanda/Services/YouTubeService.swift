import Foundation

struct YouTubeVideo: Codable {
    let id: String
    let title: String
    let thumbnailURL: String
    
    enum CodingKeys: String, CodingKey {
        case id = "videoId"
        case title = "title"
        case thumbnailURL = "thumbnailUrl"
    }
}

class YouTubeService {
    static let shared = YouTubeService()
    
    // Replace with your actual YouTube API key
    private let apiKey = "AIzaSyAk0h2POSOjdofx5avh_awulsKmtrjMaVs"
    
    // Use a list of pre-approved educational video IDs
    private let safeVideoIDs = [
        "9bZkp7q19f0",  // Gangnam Style (example)
        "dQw4w9WgXcQ",  // Never Gonna Give You Up (example)
        // Add more educational video IDs here
    ]
    
    func fetchEducationalVideos(completion: @escaping (Result<[YouTubeVideo], Error>) -> Void) {
        // For now, return a pre-approved video instead of making API calls
        let randomVideo = YouTubeVideo(
            id: safeVideoIDs.randomElement() ?? "9bZkp7q19f0",
            title: "Educational Video",
            thumbnailURL: ""
        )
        completion(.success([randomVideo]))
    }
} 