import ComposableArchitecture

/// Основний редюсер для екрану списку фільмів, серіалів та персон
struct MovieListFeature: Reducer {
    
    /// Стан екрану, що містить всі необхідні дані
    struct State: Equatable {
        var movies: [Movie] = []               // Список фільмів
        var isLoading: Bool = false            // Стан завантаження
        var error: String?                     // Помилка, якщо є
        var selectedMovie: MovieThemoviedb?    // Вибраний фільм для детального перегляду
    }
    
    /// Всі можливі дії, які можуть змінити стан
    enum Action: Equatable {
        case onAppear                                             // Дія при появі екрану
        case moviesResponse(TaskResult<[Movie]>)                  // Відповідь з API для фільмів
        case movieSelected(Movie)                                 // Вибір фільму
        case movieDetailsResponse(TaskResult<MovieThemoviedb>)    // Відповідь з API для деталей фільму
        case dismissDetail                                        // Закриття детального перегляду
    }
    
    /// Залежність для роботи з API
    @Dependency(\.movieClient) var movieClient
    
    /// Основний редюсер, який обробляє всі дії
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("🔄 Початок завантаження даних")
                state.isLoading = true
                
                // Запускаємо запит для завантаження фільмів
                return .run { send in
                    do {
                        let movies = try await movieClient.getPopularMovies()
                        print("✅ Успішно отримано фільми")
                        await send(.moviesResponse(.success(movies)))
                    } catch {
                        print("❌ Помилка при отриманні фільмів: \(error)")
                        await send(.moviesResponse(.failure(error)))
                    }
                }
                
            case let .moviesResponse(.success(movies)):
                state.movies = movies
                state.isLoading = false
                return .none
                
            case let .moviesResponse(.failure(error)):
                print("⚠️ Помилка: \(error.localizedDescription)")
                state.isLoading = false
                state.error = error.localizedDescription
                return .none
                
            case let .movieSelected(movie):
                // При виборі фільму завантажуємо його деталі
                return .run { send in
                    do {
                        let details = try await movieClient.getMovieDetails(movie.id)
                        await send(.movieDetailsResponse(.success(details)))
                    } catch {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
                
            case let .movieDetailsResponse(.success(movie)):
                state.selectedMovie = movie
                return .none
                
            case let .movieDetailsResponse(.failure(error)):
                print("⚠️ Помилка при завантаженні деталей: \(error.localizedDescription)")
                state.error = error.localizedDescription
                return .none
                
            case .dismissDetail:
                // При закритті детального перегляду очищаємо відповідні поля
                state.selectedMovie = nil
                return .none
            }
        }
    }
} 
