//
//  Network.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 25.07.2022.
//

import Foundation
import Alamofire

class Network {
    
    let baseUrl = "https://api.themoviedb.org/3/"
    static let shared = Network()
    
    private init() {}
    func fetchData2<T>(with type: String? = "movie/popular", page: Int = 1, query: String? = nil, model: T.Type, completion : @escaping (Result<T, CustomError>) -> Void) where T: Decodable {
        var apiParameter = ["api_key": NetworkConstants.apiKey2, "language": Locale.current.languageCode]
        if page != 1 {apiParameter["page"] = String(describing: page)}
        if query != nil {apiParameter["query"] = query}
        var safeType = "movie/popular"
        if type != nil {safeType = type!}
        print("\(baseUrl)\(safeType)?")
        print(apiParameter)
        AF.request("\(baseUrl)\(safeType)?", parameters: apiParameter).response { (response) in
            if response.error == nil, let safeData = response.data {
                do {
                    let result = try JSONDecoder().decode(model, from: safeData)
                    print(result)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(CustomError.networkError))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion(.failure(CustomError.networkError))
                }
            }
        }
    }
}




