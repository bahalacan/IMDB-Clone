//
//  ReviewCell.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 18.08.2022.
//

import UIKit

class ReviewCell: UITableViewCell {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var username: UILabel!
    
    func configure(review: ReviewResult) {
        date.adjustsFontSizeToFitWidth = true
        date.minimumScaleFactor = 0.2
        username.adjustsFontSizeToFitWidth = true
        username.minimumScaleFactor = 0.2
        
        date.text = review.created_at
        content.text = review.content
        username.text = review.author_details?.username
        
        if review.author_details?.avatar_path == nil {
            self.avatar.image = UIImage(named: ImageConstants.placeholderActorImage)
        } else {
            avatar.kf.setImage(with: URL(string: NetworkConstants.imageURL + (review.author_details?.avatar_path ?? "") ))
        }
    }
    
}
