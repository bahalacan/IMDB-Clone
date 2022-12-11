//
//  Person.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 19.08.2022.
//

import Foundation

struct Person: Codable {
    let results: [PersonResults]?
    let total_pages: Int?
}

struct PersonResults: Codable {
    let name: String?
    let profile_path: String?
    let id: Int?
}

struct PersonMovies: Codable {
    let cast: [MovieResults]?
}
