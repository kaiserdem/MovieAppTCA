import Foundation

struct TVThemoviedb: Equatable, Identifiable, Codable {
    let id: Int
    let name: String?
    let overview: String?
    let posterPath: String?
    let firstAirDate: String?
    let voteAverage: Double?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }
} 