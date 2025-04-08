import ComposableArchitecture

struct MovieListFeature: Reducer {
    struct State: Equatable {
        var movies: [Movie] = []
        var tvShows: [TVShow] = []
        var persons: [Person] = []
        var isLoading: Bool = false
        var error: String?
        var selectedMovie: MovieThemoviedb?
        var selectedTVShow: TVThemoviedb?
        var selectedPerson: PersonThemoviedb?
    }
    
    enum Action: Equatable {
        case onAppear
        case moviesResponse(TaskResult<[Movie]>)
        case tvShowsResponse(TaskResult<[TVShow]>)
        case personsResponse(TaskResult<[Person]>)
        case movieSelected(Movie)
        case tvShowSelected(TVShow)
        case personSelected(Person)
        case movieDetailsResponse(TaskResult<MovieThemoviedb>)
        case tvShowDetailsResponse(TaskResult<TVThemoviedb>)
        case personDetailsResponse(TaskResult<PersonThemoviedb>)
        case dismissDetail
    }
    
    @Dependency(\.movieClient) var movieClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                print("🔄 Початок завантаження даних")
                state.isLoading = true
                
                return .merge(
                    .run { send in
                        do {
                            let movies = try await movieClient.fetchMovies()
                            print("✅ Успішно отримано фільми")
                            await send(.moviesResponse(.success(movies)))
                        } catch {
                            print("❌ Помилка при отриманні фільмів: \(error)")
                            await send(.moviesResponse(.failure(error)))
                        }
                    },
                    .run { send in
                        do {
                            let tvShows = try await movieClient.fetchTVShows()
                            print("✅ Успішно отримано серіали")
                            await send(.tvShowsResponse(.success(tvShows)))
                        } catch {
                            print("❌ Помилка при отриманні серіалів: \(error)")
                            await send(.tvShowsResponse(.failure(error)))
                        }
                    },
                    .run { send in
                        do {
                            let persons = try await movieClient.fetchPersons()
                            print("✅ Успішно отримано персон")
                            await send(.personsResponse(.success(persons)))
                        } catch {
                            print("❌ Помилка при отриманні персон: \(error)")
                            await send(.personsResponse(.failure(error)))
                        }
                    }
                )
                
            case let .moviesResponse(.success(movies)):
                print("📱 Оновлення стану з \(movies.count) фільмами")
                state.movies = movies
                state.isLoading = state.tvShows.isEmpty && state.persons.isEmpty
                return .none
                
            case let .tvShowsResponse(.success(tvShows)):
                print("📱 Оновлення стану з \(tvShows.count) серіалами")
                state.tvShows = tvShows
                state.isLoading = state.movies.isEmpty && state.persons.isEmpty
                return .none
                
            case let .personsResponse(.success(persons)):
                print("📱 Оновлення стану з \(persons.count) персонами")
                state.persons = persons
                state.isLoading = state.movies.isEmpty && state.tvShows.isEmpty
                return .none
                
            case let .moviesResponse(.failure(error)),
                 let .tvShowsResponse(.failure(error)),
                 let .personsResponse(.failure(error)):
                print("⚠️ Помилка: \(error.localizedDescription)")
                state.isLoading = false
                state.error = error.localizedDescription
                return .none
                
            case let .movieSelected(movie):
                return .run { send in
                    do {
                        let details = try await movieClient.fetchMovieDetails(movie.id)
                        await send(.movieDetailsResponse(.success(details)))
                    } catch {
                        await send(.movieDetailsResponse(.failure(error)))
                    }
                }
                
            case let .tvShowSelected(tvShow):
                guard let id = tvShow.id else { return .none }
                return .run { send in
                    do {
                        let details = try await movieClient.fetchTVShowDetails(id)
                        await send(.tvShowDetailsResponse(.success(details)))
                    } catch {
                        await send(.tvShowDetailsResponse(.failure(error)))
                    }
                }
                
            case let .personSelected(person):
                return .run { send in
                    do {
                        let details = try await movieClient.fetchPersonDetails(person.id)
                        await send(.personDetailsResponse(.success(details)))
                    } catch {
                        await send(.personDetailsResponse(.failure(error)))
                    }
                }
                
            case let .movieDetailsResponse(.success(movie)):
                state.selectedMovie = movie
                return .none
                
            case let .tvShowDetailsResponse(.success(show)):
                state.selectedTVShow = show
                return .none
                
            case let .personDetailsResponse(.success(person)):
                state.selectedPerson = person
                return .none
                
            case let .movieDetailsResponse(.failure(error)),
                 let .tvShowDetailsResponse(.failure(error)),
                 let .personDetailsResponse(.failure(error)):
                print("⚠️ Помилка при завантаженні деталей: \(error.localizedDescription)")
                state.error = error.localizedDescription
                return .none
                
            case .dismissDetail:
                state.selectedMovie = nil
                state.selectedTVShow = nil
                state.selectedPerson = nil
                return .none
            }
        }
    }
} 