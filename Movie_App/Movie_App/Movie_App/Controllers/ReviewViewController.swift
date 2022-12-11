//
//  ReviewViewController.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 17.08.2022.
//

import UIKit

class ReviewViewController: UIViewController {
    @IBOutlet weak var reviewTableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reviewTableView: UITableView! {
        didSet {
            reviewTableView.dataSource = self
            reviewTableView.register(UINib(nibName: "ReviewCell", bundle: nil), forCellReuseIdentifier: "ReviewCell")
        }
    }
    
    var reviews: [ReviewResult] = [] {
        didSet {
            reviewTableView.reloadData()
        }
    }
    var movieId: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Network.shared.fetchData2(with: NetworkConstants.reviewUrl(with: movieId ?? -1) ,model: Review.self) { result in
            switch result {
            case .success(let response):
                self.reviews = response.results ?? []
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell", for: indexPath) as! ReviewCell
        cell.configure(review: reviews[indexPath.row])
        return cell
    }
    
    
}
