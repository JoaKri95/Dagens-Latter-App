

import SwiftUI

struct StarRatingView: View {
    @Binding var rating: Int
    let maxRatingNumber = 5
    
    var body: some View {
        HStack {
            ForEach(1...maxRatingNumber, id: \.self) { number in
                Image(systemName: number > rating ? "star" : "star.fill")
                    .foregroundColor(number > rating ? Color.gray : Color.yellow)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
}

#Preview {
    StarRatingView(rating: .constant(4))
}
