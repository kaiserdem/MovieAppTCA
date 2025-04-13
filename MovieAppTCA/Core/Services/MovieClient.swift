import Foundation
import Dependencies

/// Клієнт для роботи з фільмами через API
struct MovieClient {
    /// Отримання списку популярних фільмів
    var getPopularMovies: @Sendable () async throws -> [Movie]
    
    /// Отримання детальної інформації про фільм за ID
    var getMovieDetails: @Sendable (Int) async throws -> MovieThemoviedb
}

/// Реєстрація MovieClient як залежності для TCA
extension MovieClient: DependencyKey {
    static let liveValue = MovieClient(
        getPopularMovies: {
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
        getMovieDetails: { id in
            let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(AppConstants.API.themoviedbKey)")!
            print("🌐 Запит до API (деталі фільму): \(url)")
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Статус відповіді: \(httpResponse.statusCode)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(MovieThemoviedb.self, from: data)
        }
    )
}

/// Розширення для доступу до MovieClient через систему залежностей TCA
extension DependencyValues {
    var movieClient: MovieClient {
        get { self[MovieClient.self] }
        set { self[MovieClient.self] = newValue }
    }
}

/// Структура відповіді API для списку фільмів
struct MovieResponse: Codable {
    let results: [Movie]
} 