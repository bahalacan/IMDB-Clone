//
//  MovieDetail.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 27.07.2022.
//

import Foundation

struct MovieDetail: Codable {
    var title: String?
    var original_language: String?
    var original_title: String?
    var release_date: String?
    var budget: Int?
    var revenue: Int?
    var overview: String?
    var runtime: Int?
    var poster_path: String?
    var homepage: String?
    let backdrop_path: String?
    var production_companies: [ProductionCompany]?
    var genres: [Genre]?
}

struct ProductionCompany: Codable {
    var logo_path: String?
    var name: String?
    var origin_country: String?
}

struct Genre: Codable {
    var name: String?
}

