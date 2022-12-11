//
//  Review.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 17.08.2022.
//

import Foundation

struct Review: Codable {
    let results: [ReviewResult]?
}

struct ReviewResult: Codable {
    var author_details: Author?
    var content: String?
    var created_at: String
}

struct Author: Codable {
    var username: String?
    var avatar_path: String?
}
