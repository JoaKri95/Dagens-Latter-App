

import Foundation

struct JokeAttributesArrays {
    
    let availableCategoryArray: [String] = [
        "Programming",
        "Misc",
        "Dark",
        "Pun",
        "Spooky",
        "Christmas"
    ]
    
    var availableFlags: [String: Bool] = [
        "nsfw": false,
        "religious": false,
        "political": false,
        "racist": false,
        "sexist": false,
        "explicit": false    ]
    
    let availableJokeTypes: [String] = [
        "single",
        "twopart"
    ]
    
    let availableLanguageArray: [String : String] = [
        "es": "Spanish",
        "fr": "French",
        "pt": "Portuguese",
        "en": "English",
        "de": "German",
        "cs": "Czech",
    ]
}
