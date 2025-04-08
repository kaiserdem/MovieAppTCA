import Foundation

struct PersonThemoviedb: Equatable, Identifiable, Codable {
    let id: Int
    let name: String
    let originalName: String
    let profilePath: String?
    let knownForDepartment: String
    let popularity: Double
    let knownFor: [KnownFor]
    
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(profilePath)")
    }
}

struct KnownFor: Equatable, Identifiable, Codable {
    let id: Int
    let title: String?
    let originalTitle: String?
    let posterPath: String?
    
    var posterURL: URL? {
        guard let posterPath = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")
    }
} 