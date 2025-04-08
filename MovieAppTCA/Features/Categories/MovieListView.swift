import SwiftUI
import ComposableArchitecture

struct MovieListView: View {
    let store: StoreOf<MovieListFeature>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            NavigationView {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Топ фільмів
                        CategorySection(title: "Popular movies") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewStore.movies) { movie in
                                        MovieCard(movie: movie)
                                            .onTapGesture {
                                                viewStore.send(.movieSelected(movie))
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Топ серіалів
                        CategorySection(title: "Popular TV series") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewStore.tvShows) { show in
                                        TVShowCard(show: show)
                                            .onTapGesture {
                                                viewStore.send(.tvShowSelected(show))
                                            }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Популярні персони
                        CategorySection(title: "Popular people") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(viewStore.persons) { person in
                                        PersonCard(person: person)
                                            .onTapGesture {
                                                viewStore.send(.personSelected(person))
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
                .navigationTitle("Categories")
                .foregroundColor(.white)
                .navigationBarTitleTextColor(.white)
                .onAppear {
                    viewStore.send(.onAppear)
                }
                .fullScreenCover(item: viewStore.binding(
                    get: { $0.selectedMovie },
                    send: { _ in .dismissDetail }
                )) { movie in
                    MovieDetailView(store: store, movie: movie)
                }
                .fullScreenCover(item: viewStore.binding(
                    get: { $0.selectedTVShow },
                    send: { _ in .dismissDetail }
                )) { show in
                    TVShowDetailView(store: store, show: show)
                }
                .fullScreenCover(item: viewStore.binding(
                    get: { $0.selectedPerson },
                    send: { _ in .dismissDetail }
                )) { person in
                    PersonDetailView(store: store, person: person)
                }
            }
            .customNavigationBar()
        }
    }
}

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack(spacing: 12) {
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.headline)
                
                Text(movie.overview)
                    .font(.subheadline)
                    .lineLimit(2)
                
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