
import SwiftUI
import CoreData

struct AddNewJokeView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var jokeCounter: StoredJokeCounter
    @State var availablePickerOptions = JokeAttributesArrays()
    @State private var jokes: [Joke] = []
    
    
    @State private var pickerLabel: String = ""
    
    @State private var jokeType: String = "single"
    
    @State private var jokeText: String = ""
    
    @State private var setupText: String = ""
    @State private var deliveryText: String = ""
    
    @State private var rating = 0
    
    @State private var jokeLanguage: String = "en"
    
    @State private var jokeCategory: String = "Programming"
    
    @State private var flags: String = ""
    
    @State private var safeJoke: Bool = true
    
    @State private var alertType: AlertType?
    
    
    enum AlertType: Identifiable {
        case validationError(String)
        case saveConfirmation(String)
        
        var id: String {
            switch self {
            case .validationError(let message):
                return "validationError- \(message)"
            case .saveConfirmation(let message):
                return "saveConfirmation- \(message)"
            }
        }
    }
    
    
    var body: some View {
        List {
            Section(header: Text("Write Joke")) {
                JokePickerView(pickerLabel: "Joke Type", selectedOption: $jokeType, availableOptions: .array(availablePickerOptions.availableJokeTypes))
                    .onChange(of: jokeType) {
                        jokeText = ""
                        setupText = ""
                        deliveryText = ""
                        rating = 0
                    }
                
                
                if(jokeType == "single"){
                    TextField("Enter joke here...", text: $jokeText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    
                    StarRatingView(rating: $rating)
                } else {
                    TextField("Enter joke setup here...", text: $setupText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    TextField("Enter joke delivery here...", text: $deliveryText)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textFieldStyle(.roundedBorder)
                    StarRatingView(rating: $rating)
                }
                
            }
            
            
            Section(header: Text("Set Joke Language")) {
                JokePickerView(pickerLabel: "Joke Language", selectedOption: $jokeLanguage, availableOptions: .dictionary(availablePickerOptions.availableLanguageArray))
            }
            
            Section(header: Text("Set Joke Category")) {
                JokePickerView(pickerLabel: "Joke Category", selectedOption: $jokeCategory, availableOptions: .array(availablePickerOptions.availableCategoryArray))
            }
            
            Section("Flags") {
                ForEach(availablePickerOptions.availableFlags.keys.sorted(), id: \.self) { key in
                    HStack {
                        Text(key.capitalized)
                        
                        Spacer()
                        
                        Image(systemName: availablePickerOptions.availableFlags[key]! ? "checkmark.square.fill" : "square")
                            .foregroundColor(availablePickerOptions.availableFlags[key]! ? .blue : .gray)
                            .onTapGesture {
                                // Toggle the boolean value
                                availablePickerOptions.availableFlags[key]!.toggle()
                                safeJoke.toggle()
                            }
                    }
                    .padding(2)
                }
            }
            
            
            
            Button {
                let isSingleJokeValid = jokeType == "single" && validateInput(input: jokeText)
                let isTwoPartJokeValid = jokeType == "twopart" && validateInput(input: setupText) && validateInput(input: deliveryText)
                
                if isSingleJokeValid || isTwoPartJokeValid {
                    saveNewJoke()
                    print("Going to save joke func")
                    alertType = .saveConfirmation("Joke saved successfully!")
                } else {
                    let errorMessage = jokeType == "single" ? "Please fill out the joke field!" : "Please fill out the Setup and Delivery fields!"
                    alertType = .validationError(errorMessage)
                }
            } label: {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.saveButton)
                    .cornerRadius(10)
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .alert(item: $alertType) { currentAlertType in
                switch currentAlertType {
                case .validationError(let message):
                    return Alert(title: Text("Validation Error"), message: Text(message), dismissButton: .default(Text("OK")))
                case .saveConfirmation(let message):
                    return Alert(title: Text("Success"), message: Text(message), dismissButton: .default(Text("OK")) {
                        presentationMode.wrappedValue.dismiss()
                    })
                }
            }  
            
        }
    }
    
    func saveNewJoke() {
        // Create a new Joke instance
        let newJoke = Joke(context: viewContext)
        
        newJoke.isUserCreated = true
        if rating == 0 {
            newJoke.isRated = false
        } else {
            newJoke.isRated = true
        }
        
        newJoke.rating = Int16(rating)
        newJoke.id = UUID().uuidString
        newJoke.category = jokeCategory
        newJoke.type = jokeType
        newJoke.setup = setupText
        newJoke.delivery = deliveryText
        newJoke.joke = jokeText
        newJoke.safe = safeJoke
        newJoke.lang = jokeLanguage
        
        // Create a new Flags instance
        let newFlags = Flags(context: viewContext)
        // Set each flag based on the availableFlags state
        newFlags.nsfw = availablePickerOptions.availableFlags["nsfw"] ?? false
        newFlags.religious = availablePickerOptions.availableFlags["religious"] ?? false
        newFlags.political = availablePickerOptions.availableFlags["political"] ?? false
        newFlags.racist = availablePickerOptions.availableFlags["racist"] ?? false
        newFlags.sexist = availablePickerOptions.availableFlags["sexist"] ?? false
        newFlags.explicit = availablePickerOptions.availableFlags["explicit"] ?? false
        
        // Assign the flags to the joke
        newJoke.flags = newFlags
        
        do {
            try viewContext.save()
            if newJoke.isRated {
                jokeCounter.ratedJokesStored += 1
            } else {
                jokeCounter.unratedJokesStored += 1
            }
            
            print("Joke saved successfully!")
        } catch {
            print("Error saving usermade joke: \(error.localizedDescription)")
        }
    }
}



