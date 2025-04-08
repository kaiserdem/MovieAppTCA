import Foundation

struct Person: Equatable, Identifiable, Codable {
    let id: Int
    let name: String
    let profilePath: String?
    let knownForDepartment: String
    
    var profileURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
    }
} 