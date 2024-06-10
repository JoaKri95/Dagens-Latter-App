

import SwiftUI

struct JokeDetailView: View {
    
    @ObservedObject var jokeDetailed: Joke
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    
    @State private var showRatingAlert = false
    @State private var ratingAlertMessage = ""
    @State private var jokeType = ""
    @State private var rating = 0
    @State var commentInput = ""
    
    let jokeAttributes = JokeAttributesArrays()
    
    private var flagsDescription: String {
        guard let flagsEntity = jokeDetailed.flags else { return "No flags" }
        
        let activeFlags = jokeAttributes.availableFlags.compactMap { key, _ -> String? in
            let flagValue = flagsEntity.value(forKey: key) as? Bool ?? false
            return flagValue ? key.capitalized : nil
        }
        
        return activeFlags.isEmpty ? "Safe" : activeFlags.joined(separator: ", ")
    }
    
    
    init(jokeDetailed: Joke) {
        self.jokeDetailed = jokeDetailed
        _jokeType = State(initialValue: jokeDetailed.type ?? "")
        _rating = State(initialValue: Int(jokeDetailed.rating))
        _commentInput = State(initialValue: jokeDetailed.comment ?? "")
    }
    
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Text(jokeDetailed.category ?? "Category not found")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Text(jokeDetailed.type ?? "Type not found")
                        .font(.headline)
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    if jokeDetailed.type == "twopart", let setup = jokeDetailed.setup, let delivery = jokeDetailed.delivery {
                        Text("Setup: ")
                            .fontWeight(.semibold)
                        Text(setup)
                            .padding(.bottom)
                        Text("Delivery: ")
                            .fontWeight(.semibold)
                        Text(delivery)
                            .padding(.bottom)
                    } else if let joke = jokeDetailed.joke {
                        Text(joke)
                            .padding(.vertical)
                    }
                }
                .padding(.horizontal)
                
                Section(header: Text("Flags")) {
                    Text(flagsDescription)
                        .padding()
                }
                
                Section(header: Text("Rate and comment")){
                    StarRatingView(rating: $rating)
                    HStack{
                        TextField("Write a comment here...", text: $commentInput, axis: .vertical)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                    }
                    .swipeActions {
                        Button(role: .cancel) {
                            commentInput = ""
                        } label: {
                            Label("Angre", systemImage: "arrow.uturn.backward")
                        }
                    }
                }
                
                
                Button {
                    if rating == 0 {
                        ratingAlertMessage = "Please select a star rating before saving."
                        showRatingAlert = true
                    } else {
                        saveRatingAndComment()
                    }
                } label: {
                    Text("Save Rating")
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(Color.saveButton)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .listRowBackground(Color.clear)
                .padding(.horizontal)
                .padding(.vertical, 8)
                .alert(isPresented: $showRatingAlert) {
                    Alert(title: Text("Rating Needed"), message: Text(ratingAlertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .toolbar {
            if jokeDetailed.isUserCreated {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        JokeEditView(jokeDetailed: jokeDetailed)
                        
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.blue)
                            .clipShape(Circle())
                        
                    }
                }
            }
        }
    }
    private func saveRatingAndComment() {
        
        jokeDetailed.comment = commentInput
        
        if rating > 0 && jokeDetailed.isRated == false {
            jokeDetailed.rating = Int16(rating)
            jokeDetailed.isRated = true
            jokeCounter.unratedJokesStored -= 1
            jokeCounter.ratedJokesStored += 1
            
        } else if jokeDetailed.isRated == true {
            jokeDetailed.rating = Int16(rating)
        }
        
        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print(error.localizedDescription)
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
