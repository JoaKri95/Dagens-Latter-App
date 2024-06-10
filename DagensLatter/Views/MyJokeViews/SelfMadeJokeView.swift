

import SwiftUI
import CoreData

struct SelfMadeJokeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Joke.rating, ascending: false)],
        predicate: NSPredicate(format: "isUserCreated == %@", NSNumber(value: true)),
        animation: .default)
    private var selfMadeJokes: FetchedResults<Joke>
    
    @State private var showingAddNewJokeView = false
    
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    
    
    var body: some View {
        NavigationStack {
            
            if selfMadeJokes.isEmpty {
                VStack(spacing: 20) {
                    Spacer()
                    Image("no-jokes") 
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                    Text("No jokes made yet!")
                        .font(.title)
                        .padding()
                    
                    Button("Make New Joke") {
                        showingAddNewJokeView = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                }
            } else {
                List {
                    ForEach(selfMadeJokes){ joke in
                        NavigationLink(destination: JokeDetailView(jokeDetailed: joke)) {
                            JokeListItemView(joke: joke)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                deleteJoke(joke)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            .tint(.deleteButton)
                        }
                    }
                    .listRowBackground(Color.jokenote)
                }
                .navigationTitle("My Own Jokes")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddNewJokeView = true
                        } label: {
                            if(!selfMadeJokes.isEmpty) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color.blue)
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNewJokeView) {
            AddNewJokeView()
        }
    }
    
    func deleteJoke(_ jokeToDelete: Joke) {
        if jokeToDelete.isRated {
            jokeCounter.ratedJokesStored -= 1
        } else {
            jokeCounter.unratedJokesStored -= 1
        }
        viewContext.delete(jokeToDelete)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


#Preview {
    SelfMadeJokeView()
}



