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
    private let apiKey = "YOUR_YOUTUBE_API_KEY"
    private let baseURL = "https://www.googleapis.com/youtube/v3/search"
    
    func fetchEducationalVideos(completion: @escaping (Result<[YouTubeVideo], Error>) -> Void) {
        // Search parameters for kid-friendly educational content
        let searchQuery = "kids math learning fun"
        let maxResults = 50
        
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "part", value: "snippet"),
            URLQueryItem(name: "q", value: searchQuery),
            URLQueryItem(name: "maxResults", value: String(maxResults)),
            URLQueryItem(name: "type", value: "video"),
            URLQueryItem(name: "videoDuration", value: "short"),
            URLQueryItem(name: "videoEmbeddable", value: "true"),
            URLQueryItem(name: "safeSearch", value: "strict"),
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        guard let url = components?.url else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(YouTubeResponse.self, from: data)
                let videos = response.items.map { item in
                    YouTubeVideo(
                        id: item.id.videoId,
                        title: item.snippet.title,
                        thumbnailURL: item.snippet.thumbnails.medium.url
                    )
                }
                completion(.success(videos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

// YouTube API Response structures
private struct YouTubeResponse: Codable {
    let items: [YouTubeItem]
}

private struct YouTubeItem: Codable {
    let id: VideoID
    let snippet: Snippet
}

private struct VideoID: Codable {
    let videoId: String
}

private struct Snippet: Codable {
    let title: String
    let thumbnails: Thumbnails
}

private struct Thumbnails: Codable {
    let medium: Thumbnail
}

private struct Thumbnail: Codable {
    let url: String
} 