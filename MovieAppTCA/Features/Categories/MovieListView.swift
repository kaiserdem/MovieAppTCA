import SwiftUI
import ComposableArchitecture

/// Головний екран додатку, що відображає список фільмів
struct MovieListView: View {
    /// Store для управління станом та діями
    let store: StoreOf<MovieListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Секція з популярними фільмами
                        CategorySection(title: "Popular movies") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewStore.movies) { movie in
                                        MovieCard(movie: movie)
                                            .onTapGesture {
                                                // При кліку на картку фільму відправляємо дію вибору
                                                viewStore.send(.movieSelected(movie))
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .customBackground()
                .navigationTitle("Movies")
                .foregroundColor(.white)
                .navigationBarTitleTextColor(.white)
                .onAppear {
                    // При появі екрану завантажуємо дані
                    viewStore.send(.onAppear)
                }
                // Повноекранний перегляд деталей фільму
                .fullScreenCover(item: viewStore.binding(
                    get: { $0.selectedMovie },
                    send: { _ in .dismissDetail }
                )) { movie in
                    MovieDetailView(store: store, movie: movie)
                }
            }
            .customNavigationBar()
        }
    }
}

/// Компонент для відображення рядка з фільмом у списку
struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
            // Постер фільму
            if let url = movie.posterURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray
                }
                .frame(width: 60, height: 90)
                .cornerRadius(8)
            }
            
            // Інформація про фільм
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .lineLimit(2)
                
                // Рейтинг фільму
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
                }
                .font(.caption)
            }
        }
        .padding(.vertical, 8)
    }
} 