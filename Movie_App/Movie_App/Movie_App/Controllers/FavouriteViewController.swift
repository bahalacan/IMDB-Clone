//
//  FavouriteViewController.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 27.07.2022.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    let favouriteManager = FavouriteManager()
    @IBOutlet weak var tabbarItem: UITabBarItem!
    @IBOutlet weak var favouriteCollectionView: UICollectionView! {
        didSet {
            favouriteCollectionView.dataSource = self
            favouriteCollectionView.delegate = self
            favouriteCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            favouriteCollectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.self))
        }
    }
    var favouriteMovieList: [FavouriteMovie] = [] {
        didSet {
            favouriteCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabbarItem.title = StringConstants.tabbarFavorite
        favouriteCollectionView.contentInset = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 3)
        favouriteMovieList = favouriteManager.getAllItems()
        NotificationCenter.default.addObserver(self, selector: #selector(manageFavourite(_:)), name: NSNotification.Name(rawValue: NotificationConstants.manageFavourite), object: nil)
    }
    
    @objc func manageFavourite(_ notification: NSNotification) {
            favouriteMovieList = favouriteManager.getAllItems()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

//MARK: - Collection View Protocol
extension FavouriteViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favouriteMovieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = favouriteCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else {
            return UICollectionViewCell()
        }
        let favMovie = favouriteMovieList[indexPath.row]
        let movie = MovieResults(title: favMovie.title, date: favMovie.date, rating: favMovie.rating, poster: favMovie.poster, movieId: Int(favMovie.movieId))
        cell.star.setImage(UIImage.init(systemName: ImageConstants.filledFavouriteImage), for: .normal)
        cell.configure(movie: movie)
        cell.index = indexPath
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailViewController.self)) as? DetailViewController else {
            return
        }
        let favMovie = self.favouriteMovieList[indexPath.row]
        let movie = MovieResults(title: favMovie.title, date: favMovie.date, rating: favMovie.rating, poster: favMovie.poster, movieId: Int(favMovie.movieId))
        detailViewController.movie = movie
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width/2.1, height: UIScreen.main.bounds.height/2)
    }
}

//MARK: - Cell Manager Protocol
extension FavouriteViewController: CellManager {
    func manageFavourite(indx: Int) {
        favouriteManager.deleteItem(movie: favouriteMovieList[indx])
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationConstants.manageFavourite), object: nil, userInfo: nil)
    }
}

