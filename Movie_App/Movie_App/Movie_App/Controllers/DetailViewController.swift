//
//  DetailViewController.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 27.07.2022.
//

import UIKit
import Kingfisher
import CoreData

class DetailViewController: UIViewController {
    
    let favouriteManager = FavouriteManager()
    var starController = 0
    var movie: MovieResults? = nil
    private var movieDetail: MovieDetail? = nil
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var originalTitle: UILabel!
    @IBOutlet weak var revenue: UILabel!
    @IBOutlet weak var recommendations: UILabel!
    @IBOutlet weak var budget: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var cast: UILabel!
    @IBOutlet weak var productionCompanies: UILabel!
    @IBOutlet weak var originalLanguage: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var homepage: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    @IBOutlet weak var companyCollectionView: UICollectionView! {
        didSet {
            companyCollectionView.dataSource = self
            companyCollectionView.register(UINib(nibName: String(describing: InfoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: InfoCell.self))
        }
    }
    @IBOutlet weak var castCollectionView: UICollectionView! {
        didSet {
            castCollectionView.dataSource = self
            castCollectionView.delegate = self
            castCollectionView.register(UINib(nibName: String(describing: InfoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: InfoCell.self))
        }
    }
    @IBOutlet weak var recommendationCollectionView: UICollectionView! {
        didSet {
            recommendationCollectionView.dataSource = self
            recommendationCollectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.self))
        }
    }
    
    var favouriteMovieList: [FavouriteMovie] = []
    
    private var recommendationMovieList: [MovieResults] = [] {
        didSet {
            recommendationCollectionView.reloadData()
        }
    }
    private var actors: [Cast] = [] {
        didSet {
            castCollectionView.reloadData()
        }
    }
    private var companies: [ProductionCompany] = [] {
        didSet {
            companyCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner(onView: self.view)
        favouriteMovieList = favouriteManager.getAllItems()
        
        Network.shared.fetchData2(with: NetworkConstants.detailUrl(with: movie?.movieId ?? -1), model: MovieDetail.self) { result in
            switch result {
            case .success(let response):
                self.movieDetail = response
                self.companies = response.production_companies ?? []
                self.configure()
                self.removeSpinner()
            case .failure(let error):
                print(error)
            }
        }
        
        Network.shared.fetchData2(with: NetworkConstants.recommendationUrl(with: movie?.movieId ?? -1), model: Movie.self) { result in
            switch result {
            case .success(let response):
                self.recommendationMovieList = response.results ?? []
            case .failure(let error):
                print(error)
            }
        }
        
        Network.shared.fetchData2(with: NetworkConstants.castUrl(with: movie?.movieId ?? -1), model: CastDetail.self) { result in
            switch result {
            case .success(let response):
                self.actors = response.cast ?? []
            case .failure(let error):
                print(error)
            }
        }
        setupLabelTap()
    }
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
        self.homepage.isUserInteractionEnabled = true
        self.homepage.addGestureRecognizer(labelTap)
    }
    
    @IBAction func reviewTapped(_ sender: Any) {
        guard let reviewViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: ReviewViewController.self)) as? ReviewViewController else {
            return
        }
        reviewViewController.movieId = movie?.movieId
        self.navigationController?.pushViewController(reviewViewController, animated: true)
    }
    
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
        if let url = URL(string: self.homepage.text ?? "") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func favoriteButtonTapped(_ sender: Any) {
        if starController == 0 {
            favoriteButton.image = UIImage.init(systemName: ImageConstants.filledFavouriteImage)
            let newFavMovie = favouriteManager.convertItem(movie: movie ?? MovieResults())
            favouriteMovieList.append(newFavMovie)
            starController = 1
        } else {
            favoriteButton.image = UIImage.init(systemName: ImageConstants.favouriteImage)
            starController = 0
            var index = 0
            for favMovie in favouriteMovieList {
                if favMovie.movieId == movie?.movieId ?? -1 {
                    favouriteManager.deleteItem(movie: favMovie)
                    favouriteMovieList.remove(at: index)
                }
                index = index + 1
            }
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationConstants.manageFavourite), object: nil, userInfo: nil)
    }
    
    
    func configure() {
        if favouriteManager.isFavourite(movieID: movie?.movieId ?? -1) {
            starController = 1
            favoriteButton.image = UIImage.init(systemName: ImageConstants.filledFavouriteImage)
        }
        budget.adjustsFontSizeToFitWidth = true
        budget.minimumScaleFactor = 0.2
        revenue.adjustsFontSizeToFitWidth = true
        revenue.minimumScaleFactor = 0.2
        originalLanguage.adjustsFontSizeToFitWidth = true
        originalLanguage.minimumScaleFactor = 0.2
        date.adjustsFontSizeToFitWidth = true
        date.minimumScaleFactor = 0.2
        runtime.adjustsFontSizeToFitWidth = true
        runtime.minimumScaleFactor = 0.2
        
        name.text = movieDetail?.title ?? ""
        var genreText = ""
        let genres = movieDetail?.genres
        for genre in genres ?? [] {
            genreText = genreText + (genre.name ?? "") + " "
        }
        genre.text =  genreText
        
        if movieDetail?.poster_path == nil {
            movieImage.image = UIImage(named: ImageConstants.placeholderMovieImage)
        } else {
            movieImage.kf.setImage(with: URL(string: NetworkConstants.imageURL + (movieDetail?.poster_path ?? "")))
        }
        
        originalTitle.text = movieDetail?.original_title ?? ""
        originalLanguage.text = movieDetail?.original_language ?? ""
        date.text = movieDetail?.release_date ?? ""
        let movieHour = (movieDetail?.runtime ?? 0)/60
        let movieMinute = (movieDetail?.runtime ?? 0) % 60
        runtime.text = "\(movieHour)\(StringConstants.hour) \(movieMinute)\(StringConstants.minute) "
        budget.text = StringConstants.budget + (movieDetail?.budget?.description ?? "")
        revenue.text = StringConstants.revenue + (movieDetail?.revenue?.description ?? "")
        recommendations.text = StringConstants.recommendations
        cast.text = StringConstants.cast
        productionCompanies.text = StringConstants.productionCompanies
        homepage.text = movieDetail?.homepage
        overview.text = movieDetail?.overview
    }
}

// MARK: - Collection View Protocol
extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.castCollectionView {
            return actors.count
        } else if collectionView == self.recommendationCollectionView {
            return recommendationMovieList.count
        } else {
            return companies.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.recommendationCollectionView {
            guard let cell = recommendationCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else {
                return UICollectionViewCell()
            }
            let movie = recommendationMovieList[indexPath.row]
            cell.star.setImage(UIImage(), for: .normal)
            cell.configure(movie: movie)
            return cell
        } else if collectionView == self.companyCollectionView {
            guard let cell = companyCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell else {
                return UICollectionViewCell()
            }
            let company = companies[indexPath.row]
            cell.configure(image: company.logo_path ?? ImageConstants.placeholderCompanyImage, info: company.origin_country ?? "", title: company.name ?? "")
            return cell
        } else {
            guard let cell = castCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell else {
                return UICollectionViewCell()
            }
            let actor = actors[indexPath.row]
            cell.configure(image: actor.profile_path ?? ImageConstants.placeholderActorImage, info: actor.character ?? "", title: actor.name ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.castCollectionView {
            guard let castViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: CastViewController.self)) as? CastViewController else {
                return
            }
            castViewController.id = self.actors[indexPath.row].id
            self.navigationController?.pushViewController(castViewController, animated: true)
        }
        
        // fix it
        else if collectionView == self.recommendationCollectionView {
            guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailViewController.self)) as? DetailViewController else {
                return
            }
            detailViewController.movie = self.recommendationMovieList[indexPath.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}



