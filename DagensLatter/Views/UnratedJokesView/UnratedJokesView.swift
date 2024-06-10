//
//  UnratedJokesView.swift
//  DagensLatter
//
//  Created by Joachim Oug Kristoffersen on 27/02/2024.
//

import SwiftUI

struct UnratedJokesView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    
    @FetchRequest(
        sortDescriptors: [],
        predicate: NSPredicate(format: "isRated == %@", NSNumber(value: false)),
        animation: .default)
    var storedUnratedJokes: FetchedResults<Joke>
    
    var demo: JokeModel
    
    var body: some View {
        NavigationStack {
            if(storedUnratedJokes.isEmpty){
                VStack {
                    Spacer()
                    Image("no-jokes")
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("No unrated jokes in store!")
                        .font(.title)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    ForEach(storedUnratedJokes){ joke in
                        NavigationLink(destination: JokeDetailView(jokeDetailed: joke)) {
                                JokeListItemView(joke: joke)
                        }
                        .listRowBackground(Color.jokenote)
                    }
                }
                .navigationTitle("Unrated Jokes")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear{
            jokeCounter.unratedJokesStored = storedUnratedJokes.count
        }
    }
}

struct JokeContentView: View {
    let joke: Joke
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if joke.type == "twopart", let setup = joke.setup, let delivery = joke.delivery {
                Text("Setup: \(setup)")
                    .font(.title)
                    .padding()
                Text("Delivery: \(delivery)")
                    .font(.title)
                    .padding()
            } else if let jokeText = joke.joke {
                Text(jokeText)
                    .font(.title)
                    .padding()
            }
        }
        .padding()
        .cornerRadius(5)
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}
