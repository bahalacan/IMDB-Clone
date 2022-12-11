//
//  FavouriteManager.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 10.08.2022.
//

import Foundation
import CoreData
import UIKit

struct FavouriteManager {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(CustomError.coreDataError)
        }
    }
    
    func getAllItems() -> [FavouriteMovie] {
        do {
            return try context.fetch(FavouriteMovie.fetchRequest())
        } catch {
            print(CustomError.coreDataError)
        }
        return []
    }
    
    func convertItem(movie: MovieResults) -> FavouriteMovie {
        let favouriteMovie = FavouriteMovie(context: context)
        favouriteMovie.movieId = Int32(movie.movieId ?? -1)
        favouriteMovie.rating = movie.rating ?? 0.0
        favouriteMovie.poster = movie.poster
        favouriteMovie.date = movie.date
        favouriteMovie.title = movie.title
        saveContext()
        return favouriteMovie
    }
    
    func isFavourite(movieID: Int) -> Bool {
        let favouriteMovies = getAllItems()
        for favouriteMovie in favouriteMovies {
            if favouriteMovie.movieId == movieID {
                return true
            }
        }
        return false
    }
    
    func deleteItem(movie: FavouriteMovie) {
        context.delete(movie)
        saveContext()
    }
}
