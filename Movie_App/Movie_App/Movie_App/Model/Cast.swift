//
//  Cast.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 3.08.2022.
//

import Foundation

struct CastDetail: Codable {
    var cast: [Cast]?
}

struct Cast: Codable {
    var name: String?
    var character: String?
    var profile_path: String?
    var id: Int?
}

struct CastInfo: Codable {
    var biography: String?
    var birthday: String?
    var deathday: String?
    var place_of_birth: String?
    var profile_path: String?
    var name: String?
}
