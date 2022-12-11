//
//  Constants.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 25.07.2022.
//

import Foundation

struct NetworkConstants {
    static let apiKey2 = "370b43d4fa38ed47d40f2c31f05388f6"
    static func detailUrl (with movieID: Int) -> String {
        return "movie/\(movieID)"
    }
    static func recommendationUrl (with movieID: Int) -> String {
        return "movie/\(movieID)/recommendations"
    }
    static func castUrl (with movieID: Int) -> String {
        return "movie/\(movieID)/credits"
    }
    static func reviewUrl (with movieID: Int) -> String {
        return "movie/\(movieID)/reviews"
    }
    static func castDetail  (with personID: Int) -> String {
        return "person/\(personID)"
    }
    static func castMovies  (with personID: Int) -> String {
        return "person/\(personID)/movie_credits"
    }
    
    static let personSearchingParameter = "search/person"
    static let movieSearchingParameter = "search/movie"
    
    static let apiKey = "?api_key=370b43d4fa38ed47d40f2c31f05388f6"
    static let imageURL = "https://image.tmdb.org/t/p/w500"
    
}

struct ImageConstants {
    static let filledFavouriteImage = "star.fill"
    static let favouriteImage = "star"
    static let placeholderCompanyImage = "placeholder_company_image"
    static let placeholderMovieImage = "placeholder_movie_image"
    static let placeholderActorImage = "placeholder_actor_image"
}

struct NotificationConstants {
    static let manageFavourite = "manageFavourite"
    static let favoriteMovieKey = "favouriteMovie"
}

struct StringConstants {
    static let budget = NSLocalizedString("budget", comment: "")
    static let hour = NSLocalizedString("hour", comment: "")
    static let minute = NSLocalizedString("minute", comment: "")
    static let revenue = NSLocalizedString("revenue", comment: "")
    static let recommendations = NSLocalizedString("recommendations", comment: "")
    static let cast = NSLocalizedString("cast", comment: "")
    static let productionCompanies = NSLocalizedString("productionCompanies", comment: "")
    static let imdbScore = NSLocalizedString("imdbScore", comment: "")
    static let tabbarPopular = NSLocalizedString("tabbarPopular", comment: "")
    static let tabbarFavorite = NSLocalizedString("tabbarFavorite", comment: "")
    static let searchFieldPlaceholder = NSLocalizedString("searchFieldPlaceholder", comment: "")
    static let dataNotFound = NSLocalizedString("dataNotFound", comment: "")
    static let birthday = NSLocalizedString("birthday", comment: "")
    static let deathday = NSLocalizedString("deathday", comment: "")
    static let birthPlace = NSLocalizedString("birthPlace", comment: "")    
}

