//
//  CollectionViewCell.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 26.07.2022.
//

import UIKit
import Kingfisher

protocol CellManager: AnyObject {
    func manageFavourite(indx: Int)
}

class MovieCell: UICollectionViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var info: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var star: UIButton!
    weak var delegate: CellManager?
    var index: IndexPath?
    
    func configure(movie: MovieResults) {
        self.layer.cornerRadius = 10
        name.adjustsFontSizeToFitWidth = true
        name.minimumScaleFactor = 0.2
        info.adjustsFontSizeToFitWidth = true
        info.minimumScaleFactor = 0.2
        
        if movie.poster == nil {
            self.poster.image = UIImage(named: ImageConstants.placeholderMovieImage)
        } else {
            poster.kf.setImage(with: URL(string: NetworkConstants.imageURL + (movie.poster ?? "") ))
        }
        
        name.text = movie.title ?? StringConstants.dataNotFound
        let rating = Double(round(10 * (movie.rating ?? 0.0) ) / 10)
        let info = (movie.date ?? "") + (rating != 0.0 ?  StringConstants.imdbScore +  rating.description : "")
        self.info.text = info
    }
    
    @IBAction func favouriteButtonTapped(_ sender: Any) {
        delegate?.manageFavourite(indx: index?.row ?? -1)
    }
}



