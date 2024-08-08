//
//  FoodAPI.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import Foundation
import Combine

class FoodAPI {
    static let shared = FoodAPI()
    
    private let baseURL: String = "https://api.spoonacular.com"
    private let apiKey: String = "71b17e5d66664474a7dbdfdcdead59bb"

    func fetchComplexSearchResults(query: String) -> AnyPublisher<ComplexSearch, Error> {
        // Hardcoded JSON string
        let jsonString = """
        {
            "results": [
                {
                    "id": 627987,
                    "title": "onion pakoda recipe",
                    "image": "https://img.spoonacular.com/recipes/627987-312x231.jpg"
                },
                {
                    "id": 651994,
                    "title": "Miniature Fruit Tarts",
                    "image": "https://img.spoonacular.com/recipes/651994-312x231.jpg"
                }
            ]
        }
        """
        
        // Convert JSON string to Data
        guard let jsonData = jsonString.data(using: .utf8) else {
            return Fail(error: URLError(.cannotParseResponse))
                .eraseToAnyPublisher()
        }
        
        return Just(jsonData)
            .decode(type: ComplexSearch.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { complexSearch in
                print("Decoded ComplexSearch: \(complexSearch)")
            })
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    
    func real_fetchComplexSearchResults(query: String) -> AnyPublisher<ComplexSearch, Error> {
        guard let url = URL(string: baseURL + "/recipes/complexSearch?apiKey=\(apiKey)&query=\(query)") else {
            return Fail(error: URLError(.badURL))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let httpResponse = output.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
//                if let jsonString = String(data: output.data, encoding: .utf8) {
//                    print("Raw JSON data: \(jsonString)")
//                }
                return output.data
            }
            .decode(type: ComplexSearch.self, decoder: JSONDecoder())
            .handleEvents(receiveOutput: { complexSearch in
                print("Decoded ComplexSearch: \(complexSearch)")
            })
            .mapError { error in
                if let decodingError = error as? DecodingError {
                    print("Decoding error: \(decodingError)")
                } else {
                    print("Error: \(error)")
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

// MARK: - API models

struct ComplexSearch: Codable {
    let results: [SearchResult]

    enum CodingKeys: String, CodingKey {
        case results
    }
}

struct SearchResult: Identifiable, Codable {
    let id: Int
    let title: String
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageURL = "image"
    }
}
