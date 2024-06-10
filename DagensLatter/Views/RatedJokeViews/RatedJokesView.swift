

import SwiftUI
import CoreData

struct RatedJokesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var categories: [String] {
        ["All"] + availablePickerOptions.availableCategoryArray
    }
    
    @State var selectedCategory = "All"

    @FetchRequest var ratedJokes: FetchedResults<Joke>
    init() {
        _ratedJokes = FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Joke.rating, ascending: false)],
            predicate: NSPredicate(format: "isRated == true"),
            animation: .default
        )
    }
    
//    @State private var showFilterSheet = false
    
    @State private var rating = 0
    
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    
    @State var availablePickerOptions = JokeAttributesArrays()
    
    
    
    var body: some View {
        NavigationStack {
            List {
                Picker("Select Category:", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
                .font(.headline)
                .fontWeight(.bold)
                .pickerStyle(MenuPickerStyle()) 
                .onChange(of: selectedCategory) { 
                    if selectedCategory == "All" {
                        ratedJokes.nsPredicate = NSPredicate(format: "isRated == true")
                    } else {
                        ratedJokes.nsPredicate = NSPredicate(format: "isRated == true AND category == %@", selectedCategory)
                    }
                }
                
                if ratedJokes.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Image(systemName: "star.slash.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("No stored jokes rated in this category!")
                                .font(.callout)
                                .fontWeight(.medium)
                                .padding()
                        }
                        Spacer()
                    }
                } else {
                    ForEach(ratedJokes){ joke in
                        NavigationLink(destination: JokeDetailView(jokeDetailed: joke)) {
                            JokeListItemView(joke: joke)
                        }
                        .listRowBackground(Color.jokenote)
                    }
                }
            }
            .navigationTitle("Rated \(selectedCategory) Jokes")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            selectedCategory = "All"
            jokeCounter.ratedJokesStored = ratedJokes.count
        }
    }
    
}




