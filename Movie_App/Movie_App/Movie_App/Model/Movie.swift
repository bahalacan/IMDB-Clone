//
//  Movie.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 25.07.2022.
//

import Foundation

struct Movie: Codable {
    let total_pages: Int?
    let results: [MovieResults]?
}

struct MovieResults: Codable {
    var title: String?
    var date: String?
    var rating: Double?
    var poster: String?
    var movieId: Int?
    
    enum CodingKeys: String, CodingKey {
        case title
        case rating = "vote_average"
        case poster = "poster_path"
        case date = "release_date"
        case movieId = "id"
    }
}


