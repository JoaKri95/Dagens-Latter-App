

import Foundation

struct JokeModel: Decodable {
    let error: Bool
    let category: String
    let type: String
    let setup: String?
    let delivery: String?
    let joke: String?
    let flags: Flags
    let id: Int
    let safe: Bool
    let lang: String

    struct Flags: Decodable {
        let nsfw: Bool
        let religious: Bool
        let political: Bool
        let racist: Bool
        let sexist: Bool
        let explicit: Bool
    }
}


let demoJoke = JokeModel(
    error: false,
    category: "Pun",
    type: "twopart",
    setup: "I walked into a bar once.",
    delivery: "It really hurt my head.",
    joke: nil,
    flags: JokeModel.Flags(
        nsfw: true,
        religious: false,
        political: false,
        racist: false,
        sexist: false,
        explicit: false
    ),
    id: 215,
    safe: true,
    lang: "en"
)
