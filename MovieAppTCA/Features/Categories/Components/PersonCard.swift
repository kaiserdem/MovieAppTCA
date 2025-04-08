import SwiftUI
//import MovieAppTCA_Core

struct PersonCard: View {
    let person: Person
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let url = person.profileURL {
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
                Text(person.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
                Text(person.knownForDepartment)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 150)
    }
} 
