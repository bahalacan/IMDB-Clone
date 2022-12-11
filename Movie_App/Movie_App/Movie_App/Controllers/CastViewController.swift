//
//  CastViewController.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 16.08.2022.
//

import UIKit
import Kingfisher

class CastViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var deathday: UILabel!
    @IBOutlet weak var birthPlace: UILabel!
    @IBOutlet weak var biography: UILabel!
    @IBOutlet weak var movieCollectionView: UICollectionView! {
        didSet {
            movieCollectionView.delegate = self
            movieCollectionView.dataSource = self
            movieCollectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.self))
        }
    }
    
    var id: Int?
    var movies: [MovieResults]? {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    var cast: CastInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
   
   
        
        Network.shared.fetchData2(with: NetworkConstants.castDetail(with: id ?? -1), model: CastInfo.self) { result in
            switch result {
            case .success(let response):
                self.cast = response
                self.configure()
                self.removeSpinner()
            case .failure(let error):
                print(error)
            }
        }
        
        Network.shared.fetchData2(with: NetworkConstants.castMovies(with: id ?? -1), model: PersonMovies.self) { result in
            switch result {
            case .success(let response):
                self.movies = response.cast
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure() {
        birthday.adjustsFontSizeToFitWidth = true
        birthday.minimumScaleFactor = 0.2
        deathday.adjustsFontSizeToFitWidth = true
        deathday.minimumScaleFactor = 0.2
        birthPlace.adjustsFontSizeToFitWidth = true
        birthPlace.minimumScaleFactor = 0.2
        
        biography.text = cast?.biography
        birthday.text = StringConstants.birthday + (cast?.birthday ?? StringConstants.dataNotFound)
        birthPlace.text = StringConstants.birthPlace + (cast?.place_of_birth ?? StringConstants.dataNotFound)
        deathday.text = StringConstants.deathday + (cast?.deathday ?? StringConstants.dataNotFound)
        name.text = cast?.name
        
        if cast?.profile_path == nil {
            self.poster.image = UIImage(named: ImageConstants.placeholderActorImage)
        } else {
            poster.kf.setImage(with: URL(string: NetworkConstants.imageURL + (cast?.profile_path ?? "") ))
        }
    }
}

extension CastViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let movie = movies?[indexPath.row]
        cell.star.setImage(UIImage(), for: .normal)
        cell.configure(movie: movie ?? MovieResults())
        return cell
    }
}

extension CastViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            return
        }
        detailVC.movie = self.movies?[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
