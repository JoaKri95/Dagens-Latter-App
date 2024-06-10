

import Foundation

func validateInput(input: String) -> Bool {
    return !input.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
}

