import Foundation
import Dependencies

struct MovieClient {
    var fetchMovies: @Sendable () async throws -> [Movie]
    var fetchTVShows: @Sendable () async throws -> [TVShow]
    var fetchPersons: @Sendable () async throws -> [Person]
    var fetchMovieDetails: @Sendable (Int) async throws -> MovieThemoviedb
    var fetchTVShowDetails: @Sendable (Int) async throws -> TVThemoviedb
    var fetchPersonDetails: @Sendable (Int) async throws -> PersonThemoviedb
}

extension MovieClient: DependencyKey {
    static let liveValue = MovieClient(
        fetchMovies: {
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (фільми): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let movieResponse = try decoder.decode(MovieResponse.self, from: data)
            return movieResponse.results
        },
        fetchTVShows: {
            let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (серіали): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let tvResponse = try decoder.decode(TVResponse.self, from: data)
            return tvResponse.results
        },
        fetchPersons: {
            let url = URL(string: "https://api.themoviedb.org/3/person/popular?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (персони): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let personResponse = try decoder.decode(PersonResponse.self, from: data)
            return personResponse.results
        },
        fetchMovieDetails: { id in
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (деталі фільму): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieThemoviedb.self, from: data)
        },
        fetchTVShowDetails: { id in
            let url = URL(string: "https://api.themoviedb.org/3/tv/\(id)?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (деталі серіалу): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(TVThemoviedb.self, from: data)
        },
        fetchPersonDetails: { id in
            let url = URL(string: "https://api.themoviedb.org/3/person/\(id)?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (деталі персони): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(PersonThemoviedb.self, from: data)
        }
    )
}

extension DependencyValues {
    var movieClient: MovieClient {
        get { self[MovieClient.self] }
        set { self[MovieClient.self] = newValue }
    }
}

struct MovieResponse: Codable {
    let results: [Movie]
}

struct TVResponse: Codable {
    let results: [TVShow]
}

struct PersonResponse: Codable {
    let results: [Person]
} 