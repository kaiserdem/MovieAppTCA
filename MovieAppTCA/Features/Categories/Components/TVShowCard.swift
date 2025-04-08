import SwiftUI

struct TVShowCard: View {
    let show: TVShow
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let url = show.posterURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 150, height: 225)
                .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(show.name ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                if let voteAverage = show.voteAverage {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", voteAverage))
                            .foregroundColor(.white)
                    }
                    .font(.caption)
                }
            }
        }
        .frame(width: 150)
    }
} 