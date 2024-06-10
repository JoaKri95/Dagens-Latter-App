

import SwiftUI

struct JokeEditView: View {
    
    @ObservedObject var jokeDetailed: Joke
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var jokeCategory: String
    @State private var jokeType: String
    @State private var jokeText: String
    @State private var jokeSetup: String
    @State private var jokeDelivery: String
    @State private var jokeLanguage: String
    
    @State private var safeJoke: Bool = true
    
    @State var availablePickerOptions = JokeAttributesArrays()
    
    @State private var flagsState: [String: Bool] = [
        "explicit": false,
        "nsfw": false,
        "political": false,
        "racist": false,
        "religious": false,
        "sexist": false
    ]
    
    
    init(jokeDetailed: Joke) {
        self.jokeDetailed = jokeDetailed
        _jokeCategory = State(initialValue: jokeDetailed.category ?? "")
        _jokeType = State(initialValue: jokeDetailed.type ?? "")
        _jokeText = State(initialValue: jokeDetailed.joke ?? "")
        _jokeSetup = State(initialValue: jokeDetailed.setup ?? "")
        _jokeDelivery = State(initialValue: jokeDetailed.delivery ?? "")
        _jokeLanguage = State(initialValue: jokeDetailed.lang ?? "")
        
        if let flags = jokeDetailed.flags {
            _flagsState = State(initialValue: [
                "explicit": flags.explicit,
                "nsfw": flags.nsfw,
                "political": flags.political,
                "racist": flags.racist,
                "religious": flags.religious,
                "sexist": flags.sexist
            ])
        }
    }
    
    
    var body: some View {
        
        List {
            Section(header: Text("Edit Joke")) {
                JokePickerView(pickerLabel: "Category", selectedOption: $jokeCategory, availableOptions: .array(availablePickerOptions.availableCategoryArray))
                    .font(.headline)
                    .fontWeight(.medium)
                    .padding()
                
                VStack(alignment: .leading) {
                    JokePickerView(pickerLabel: "Joke Type:", selectedOption: $jokeType, availableOptions: .array(availablePickerOptions.availableJokeTypes))
                        .font(.headline)
                        .fontWeight(.medium)
                        .padding()
                    if jokeType == "twopart" {
                        TextField("Setup", text: $jokeSetup, axis: .vertical)
                            .padding()
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                        TextField("Delivery", text: $jokeDelivery)
                            .padding()
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                    } else {
                        TextField("Write joke here...", text: $jokeText)
                            .autocorrectionDisabled(true)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                    }
                }
            }
            
            Section(header: Text("Edit Joke Language")) {
                JokePickerView(pickerLabel: "Joke Language", selectedOption: $jokeLanguage, availableOptions: .dictionary(availablePickerOptions.availableLanguageArray))
            }
            
            
            Section(header: Text("Edit Joke Flags")){
                VStack {
                    Toggle("Explicit", isOn: Binding(
                        get: { self.flagsState["explicit"] ?? false },
                        set: { self.flagsState["explicit"] = $0 }
                    ))
                    Toggle("NSFW", isOn: Binding(
                        get: { self.flagsState["nsfw"] ?? false },
                        set: { self.flagsState["nsfw"] = $0 }
                    ))
                    Toggle("Political", isOn: Binding(
                        get: { self.flagsState["political"] ?? false },
                        set: { self.flagsState["political"] = $0 }
                    ))
                    Toggle("Racist", isOn: Binding(
                        get: { self.flagsState["racist"] ?? false },
                        set: { self.flagsState["racist"] = $0 }
                    ))
                    Toggle("Religious", isOn: Binding(
                        get: { self.flagsState["religious"] ?? false },
                        set: { self.flagsState["religious"] = $0 }
                    ))
                    Toggle("Sexist", isOn: Binding(
                        get: { self.flagsState["sexist"] ?? false },
                        set: { self.flagsState["sexist"] = $0 }
                    ))
                }
                .padding(2)
            }
            
            
            Button {
                saveEdits()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Save Edits")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(Color.saveButton)
                    .cornerRadius(10)
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .navigationTitle("My Joke")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    
    private func saveEdits() {
        
        jokeDetailed.category = jokeCategory
        
        if jokeType == "twopart" {
            jokeDetailed.type = jokeType
            jokeDetailed.setup = jokeSetup
            jokeDetailed.delivery = jokeDelivery
            jokeDetailed.joke = nil
        } else if jokeType == "single" {
            jokeDetailed.type = jokeType
            jokeDetailed.joke = jokeText
            jokeDetailed.setup = nil
            jokeDetailed.delivery = nil
        }
        
        let anyFlagTrue = flagsState.contains { $1 == true }
        safeJoke = !anyFlagTrue
        
        jokeDetailed.safe = safeJoke
        
        jokeDetailed.lang = jokeLanguage
        
        if let flags = jokeDetailed.flags {
            flags.nsfw = flagsState["nsfw"] ?? false
            flags.religious = flagsState["religious"] ?? false
            flags.political = flagsState["political"] ?? false
            flags.racist = flagsState["racist"] ?? false
            flags.sexist = flagsState["sexist"] ?? false
            flags.explicit = flagsState["explicit"] ?? false
        }
        
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}




