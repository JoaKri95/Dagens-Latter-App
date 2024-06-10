

import SwiftUI

struct JokeListItemView: View {
    let joke: Joke
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(joke.category ?? "Unknown Type")
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
                .fixedSize(horizontal: false, vertical: true)
            
            if joke.type == "twopart" {
                Text("Setup: ").fontWeight(.semibold)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                Text(joke.setup ?? "Setup not available")
                    .padding(.bottom)
                    .fixedSize(horizontal: false, vertical: true)
                Text("Delivery: ").fontWeight(.semibold)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                Text(joke.delivery ?? "Delivery not available")
                    .fixedSize(horizontal: false, vertical: true)
            } else if joke.type == "single" {
                Text(joke.joke ?? "Joke not available")
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            if joke.isRated {
                StarRatingView(rating: .constant(Int(joke.rating)))
            }
        }
        .padding()
        .cornerRadius(5)
        .foregroundColor(.text)
    }
}

