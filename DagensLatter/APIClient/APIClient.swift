

import Foundation

struct APIClient {
    var getRandomJoke: (() async throws -> JokeModel)
    var getRandomJokeByLanguage: ((_ languageString: String) async throws -> JokeModel)
}

enum APIClientError: Error {
    case invalidURL
    case requestFailed(Error)
    case nonHTTPResponse
    case httpResponseCode(Int)
    case invalidData
    case decodingError(Error)
}


extension APIClient {
    
    static let live = APIClient(
    
        getRandomJoke: {
            guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any") else {
                throw APIClientError.invalidURL
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIClientError.nonHTTPResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIClientError.httpResponseCode(httpResponse.statusCode)
                }

                let jokeData = try JSONDecoder().decode(JokeModel.self, from: data)
                return jokeData
                
            } catch {
                throw APIClientError.requestFailed(error)
            }
        },
        
        getRandomJokeByLanguage: { languageString in
            guard let url = URL(string: "https://v2.jokeapi.dev/joke/Any?lang=\(languageString)") else {
                throw APIClientError.invalidURL
            }

            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIClientError.nonHTTPResponse
                }
                
                guard httpResponse.statusCode == 200 else {
                    throw APIClientError.httpResponseCode(httpResponse.statusCode)
                }

                let jokeData = try JSONDecoder().decode(JokeModel.self, from: data)
                return jokeData
                
            } catch {
                throw APIClientError.requestFailed(error)
            }
        }
    )
}


