import SwiftUI
import ComposableArchitecture

struct MovieDetailView: View {
    let store: StoreOf<MovieListFeature>
    let movie: MovieThemoviedb
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        if let posterPath = movie.posterPath {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(height: 500)
                            .frame(maxWidth: .infinity)
                            .clipped()
                        }
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 100)
                        
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Back")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.6))
                            )
                        }
                        .padding(.top, 50)
                        .padding(.leading, 16)
                    }
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        Text(movie.overview)
                            .font(.body)
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .padding(.horizontal)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .customBackground()
        }
    }
} 
