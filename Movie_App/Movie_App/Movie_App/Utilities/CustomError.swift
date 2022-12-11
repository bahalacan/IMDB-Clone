//
//  CustomError.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 25.07.2022.
//

import Foundation

enum CustomError: String, Error {
    
    case networkError =  "Some Network Error."
    case coreDataError = "Core Data Error"
    
}

