

import SwiftUI
import CoreData

struct HomeScreen: View {
    
    @AppStorage("isDarkMode") var isDarkMode = false {
        didSet {
            print("Dark mode is now \(isDarkMode ? "ON" : "OFF")")
        }
    }
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    
    var demoJoke: JokeModel
    @State private var joke: JokeModel?
    @State private var isLoading: Bool = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var languagePickerLabel: String = ""
    @State private var selectedLanguage = "en"
    
    
    let availablePickerOptions = JokeAttributesArrays()
    var fetcher = APIClient.live
    
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Spacer()
                
                if isLoading {
                    VStack {
                        ProgressView("Fetching joke...")
                        Text("Please wait while we fetch a joke.")
                            .padding()
                    }
                    
                    Spacer()
                } else {
                    if let joke = joke {
                        GroupBox {
                            HStack {
                                Text(joke.category)
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .padding()
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                JokePickerView(pickerLabel: languagePickerLabel, selectedOption: $selectedLanguage, availableOptions: .dictionary(availablePickerOptions.availableLanguageArray))
                            }
                            .padding()
                            
                            VStack(alignment: .leading) {
                                if joke.type == "twopart", let setup = joke.setup, let delivery = joke.delivery {
                                    Text("Setup: \(setup)")
                                        .font(.title)
                                        .padding()
                                    Text("Delivery: \(delivery)")
                                        .font(.title)
                                        .padding()
                                } else if let joke = joke.joke {
                                    Text(joke)
                                        .font(.title)
                                        .padding()
                                }
                            }
                            .padding()
                            .foregroundColor(.text)
                        }
                        .padding(.horizontal)
                        .backgroundStyle(.jokenote)
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button("Save Joke") {
                                saveJoke(from: joke, in: viewContext)
                            }
                            .padding()
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color.saveButton)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            
                            Button("Fetch Joke") {
                                Task {
                                    await fetchJoke()
                                }
                            }
                            .padding()
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color.blueButton)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                        .padding()
                        .cornerRadius(5)
                        .shadow(radius: 5)
                        
                        Spacer()
                    }
                }
            }
            .navigationTitle("Laugh of the \(isDarkMode ? "Night" : "Day")")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                isDarkMode.toggle()
            }) {
                Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
            })
            .onAppear {
                Task {
                    await fetchJoke()
                }
            }
            .alert(isPresented: $showAlert) { // Alert for duplicate jokes
                Alert(title: Text("Duplicate Joke"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        
    }
    
    func fetchJoke() async {
        isLoading = true
        do {
            let fetchedJoke = try await fetcher.getRandomJokeByLanguage(selectedLanguage)
            DispatchQueue.main.async {
                self.joke = fetchedJoke
                self.isLoading = false
            }
        } catch {
            print("Error fetching joke: \(error)")
            isLoading = false
        }
    }
    
    func saveJoke(from jokeResponse: JokeModel, in context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Joke> = Joke.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", jokeResponse.id)
        
        do {
            let existingJokes = try context.fetch(fetchRequest)
            if existingJokes.isEmpty {
                
                let jokeEntity = Joke(context: context)
                jokeEntity.id = String(jokeResponse.id)
                jokeEntity.isUserCreated = false
                jokeEntity.isRated = false
                jokeEntity.category = jokeResponse.category
                jokeEntity.type = jokeResponse.type
                jokeEntity.setup = jokeResponse.setup
                jokeEntity.delivery = jokeResponse.delivery
                jokeEntity.joke = jokeResponse.joke ?? ((jokeResponse.setup ?? "") + (jokeResponse.delivery ?? ""))
                jokeEntity.safe = jokeResponse.safe
                jokeEntity.lang = jokeResponse.lang
                
                let flagsEntity = Flags(context: context)
                flagsEntity.nsfw = jokeResponse.flags.nsfw
                flagsEntity.religious = jokeResponse.flags.religious
                flagsEntity.political = jokeResponse.flags.political
                flagsEntity.racist = jokeResponse.flags.racist
                flagsEntity.sexist = jokeResponse.flags.sexist
                flagsEntity.explicit = jokeResponse.flags.explicit
                
                jokeEntity.flags = flagsEntity
                
                try context.save()
                jokeCounter.unratedJokesStored += 1
                print("Joke saved successfully!")
            } else {
                print("Duplicate joke, not saving.")
                alertMessage = "Dont tell/save the same joke twice!"
                showAlert = true
            }
        } catch let error as NSError {
            print("Could not fetch or save. \(error), \(error.userInfo)")
        }
    }
}


#Preview {
    HomeScreen(demoJoke: demoJoke)
}
