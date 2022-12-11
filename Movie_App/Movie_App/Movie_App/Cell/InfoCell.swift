//
//  InfoCell.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 7.08.2022.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var info: UILabel!
    
    func configure(image: String, info: String, title: String) {
        self.layer.cornerRadius = 10
        self.title.adjustsFontSizeToFitWidth = true
        self.title.minimumScaleFactor = 0.2
        self.info.adjustsFontSizeToFitWidth = true
        self.info.minimumScaleFactor = 0.2
        
        if image == ImageConstants.placeholderCompanyImage {
            self.poster.image = UIImage(named: image)
        } else if image == ImageConstants.placeholderActorImage {
            self.poster.image = UIImage(named: image)
        } else {
            self.poster.kf.setImage(with: URL(string: NetworkConstants.imageURL + image))
        }
        
        self.title.text = title
        self.info.text = info
    }
}
