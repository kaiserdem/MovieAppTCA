import SwiftUI
import ComposableArchitecture

struct PersonDetailView: View {
    let store: StoreOf<MovieListFeature>
    let person: PersonThemoviedb
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ZStack(alignment: .topLeading) {
                        if let profilePath = person.profilePath {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(profilePath)")) { image in
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
                    
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(person.name)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            if person.name != person.originalName {
                                Text(person.originalName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .foregroundColor(.white)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 16)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Департамент")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(person.knownForDepartment)
                                .foregroundColor(.gray)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Популярність")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text(String(format: "%.1f", person.popularity))
                                .foregroundColor(.gray)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Відомі роботи")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(person.knownFor, id: \.id) { work in
                                        VStack(alignment: .leading) {
                                            if let posterPath = work.posterPath {
                                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(posterPath)")) { image in
                                                    image
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                } placeholder: {
                                                    Rectangle()
                                                        .fill(Color.gray.opacity(0.3))
                                                }
                                                .frame(width: 100, height: 150)
                                                .cornerRadius(8)
                                            }
                                            
                                            Text(work.title ?? work.originalTitle ?? "")
                                                .font(.caption)
                                                .foregroundColor(.white)
                                                .lineLimit(2)
                                                .frame(width: 100)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
            .customBackground()
        }
    }
} 