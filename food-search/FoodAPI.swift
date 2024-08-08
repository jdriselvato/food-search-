//
//  FoodAPI.swift
//  food-search
//
//  Created by John Riselvato on 2024/8/8.
//

import Foundation
import Combine

protocol FoodAPIProtocol {
    func fetchComplexSearchResults(query: String) -> AnyPublisher<ComplexSearch, Error>
    func fetchRecipeResult(id: Int) -> AnyPublisher<RecipeResult, Error>
}

class FoodAPI: FoodAPIProtocol {
    static let shared = FoodAPI()
    
    private let baseURL: String = "https://api.spoonacular.com"
    private let apiKey: String = "94df60d6e6c74d1eb07921c1df34f68d"
    
    func fetchComplexSearchResults(query: String) -> AnyPublisher<ComplexSearch, Error> {
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
    
    func fetchRecipeResult(id: Int) -> AnyPublisher<RecipeResult, Error> {
        guard let url = URL(string: baseURL + "/recipes/\(id)/information?apiKey=\(apiKey)") else {
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
                return output.data
            }
            .decode(type: RecipeResult.self, decoder: JSONDecoder())
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


struct RecipeResult: Identifiable, Codable {
    let id: Int
    let extendedIngredients: [ExtendedIngredients]
    let readyInMinutes: Int
    let summary: String
    let instructions: String

    enum CodingKeys: String, CodingKey {
        case id
        case extendedIngredients
        case readyInMinutes
        case summary
        case instructions
    }
    
    var readyInMinutesFormatted: String {
        return "Ready in \(readyInMinutes) minutes"
    }
}

struct ExtendedIngredients: Identifiable, Codable, Hashable {
    let id: Int
    let originalName: String

    enum CodingKeys: String, CodingKey {
        case id
        case originalName = "original"
    }
}
