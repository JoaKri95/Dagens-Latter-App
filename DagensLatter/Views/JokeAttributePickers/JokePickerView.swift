

import SwiftUI

struct JokePickerView: View {
    
    enum AvailableArrayOptions {
        case array([String])
        case dictionary([String : String])
    }
    
    let pickerLabel: String
    @Binding var selectedOption: String
    let availableOptions: AvailableArrayOptions
   
    
    var body: some View {
        Picker("\(pickerLabel)", selection: $selectedOption) {
            switch availableOptions {
            case .array(let array):
                ForEach(array, id: \.self) { option in
                    Text(option).tag(option)
                }
            case .dictionary(let dictionary):
                ForEach(dictionary.keys.sorted(), id: \.self) { key in
                    Text(dictionary[key] ?? key).tag(key)
                }
            }
        }
        .pickerStyle(.menu)
    }
    
}


