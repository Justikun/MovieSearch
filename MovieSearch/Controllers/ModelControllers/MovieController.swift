//
//  MovieController.swift
//  MovieSearch
//
//  Created by Justin Lowry on 1/7/22.
//

import UIKit

class MovieController {
    // MARK: - Properties
    
    static let baseURL = URL(string: "https://api.themoviedb.org")
    static let versionComponent = "3"
    static let searchComponent = "search"
    static let movieComponent = "movie"
    static let imageBaseURL = URL(string: "https://image.tmdb.org/t/p/w500")
    
    
    static let apiKeyKey = "api_key"
    static let apiKeyValue = "bb5d1968c6b3755d6d5f1e8bca29ccbe"
    
    static let searchTermKey = "query"

    
    
    // https://api.themoviedb.org/3/search/movie?api_key=bb5d1968c6b3755d6d5f1e8bca29ccbe&query=Jack%2BReacher
    static func fetchMovies(for movieTitle: String, completion: @escaping (Result <[Movies.MovieData], NetworkError>)-> Void) {
        // URL
        guard let baseURL = baseURL else {
            return completion(.failure(.invalidURL))
        }
        
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let searchURL = versionURL.appendingPathComponent(searchComponent)
        let movieURL = searchURL.appendingPathComponent(movieComponent)
        
        var components = URLComponents(url: movieURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        let searchQuery = URLQueryItem(name: searchTermKey, value: movieTitle)
        
        components?.queryItems = [apiQuery, searchQuery]
        
        guard let finalURL = components?.url else {
            return completion(.failure(.invalidURL))
        }
        print(finalURL)
        
        // URL Session Data task
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            // Error Handling
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            // Data Check
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            // Decode Data
            do {
                let topLevelObject = try JSONDecoder().decode(Movies.self, from: data)
                let movieResults = topLevelObject.results
                var movies: [Movies.MovieData] = []
                
                for movie in movieResults {
                    movies.append(movie)
                }
                
                return completion(.success(movies))
            } catch {
                print("failed 1", error, error.localizedDescription)
                return completion(.failure(.unableToDecode))
            }
        }.resume()
    }
    
    
    // https://image.tmdb.org/t/p/w500/(imageEndpoint)

    static func fetchPosterImage(forPath movieEndPoint: String, completion: @escaping(Result<UIImage, NetworkError>) -> Void) {
        // URL
        guard let baseURL = imageBaseURL else {
            return completion(.failure(.invalidURL))
        }
        
        let imageURL = baseURL.appendingPathComponent(movieEndPoint)
        
        // Data Task
        URLSession.shared.dataTask(with: imageURL) { data, _, error in
            // Error Handling
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            // Data Check
            guard let data = data else {
                return completion(.failure(.noData))
            }
            
            // Decode Data
            guard let image = UIImage(data: data) else {
                print("Failed 2")
                return completion(.failure(.unableToDecode))
            }
            
            return completion(.success(image))
        }.resume()
    }
}
