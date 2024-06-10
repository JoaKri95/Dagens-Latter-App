

import Foundation

class StoredJokeCounter: ObservableObject {
    @Published var unratedJokesStored: Int {
        didSet {
            UserDefaults.standard.set(unratedJokesStored, forKey: "unratedJokesStored")
        }
    }

    @Published var ratedJokesStored: Int {
        didSet {
            UserDefaults.standard.set(ratedJokesStored, forKey: "ratedJokesStored")
        }
    }

    init() {
        self.unratedJokesStored = UserDefaults.standard.integer(forKey: "unratedJokesStored")
        self.ratedJokesStored = UserDefaults.standard.integer(forKey: "ratedJokesStored")
    }
}

