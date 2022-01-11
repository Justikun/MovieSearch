//
//  Moive.swift
//  MovieSearch
//
//  Created by Justin Lowry on 1/7/22.
//

import Foundation

struct Movies: Decodable {
    let results: [MovieData]
    
    struct MovieData: Decodable {
        let title: String
        let overview: String
        let rating: Double
        let posterPath: String
        
        enum CodingKeys: String, CodingKey {
            case title = "original_title"
            case rating = "vote_average"
            case posterPath = "poster_path"
            
            case overview
        }
    }
}
