import Foundation

struct MovieThemoviedb: Equatable, Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }
} 