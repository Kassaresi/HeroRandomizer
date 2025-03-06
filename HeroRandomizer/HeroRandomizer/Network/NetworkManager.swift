//
//  NetworkManager.swift
//  HeroRandomizer
//
//  Created by Alikhan Kassiman on 2025.03.07.
//

import Foundation
import Combine

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case unknown(Error)
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please try again later."
        case .invalidResponse:
            return "Invalid response from server. Please try again later."
        case .httpError(let statusCode):
            return "HTTP Error: \(statusCode). Please try again later."
        case .decodingError:
            return "Failed to process superhero data. Please try again later."
        case .unknown:
            return "Unknown error occurred. Please try again later."
        }
    }
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://akabab.github.io/superhero-api/api"
    
    private init() {}
    
    func fetchAllHeroes() -> AnyPublisher<[Superhero], APIError> {
        guard let url = URL(string: "\(baseURL)/all.json") else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.httpError(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: [Superhero].self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? APIError {
                    return error
                } else if error is DecodingError {
                    return APIError.decodingError(error)
                } else {
                    return APIError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func fetchRandomHero() -> AnyPublisher<Superhero?, APIError> {
        return fetchAllHeroes()
            .map { heroes in
                guard !heroes.isEmpty else { return nil }
                return heroes.randomElement()
            }
            .eraseToAnyPublisher()
    }
}
