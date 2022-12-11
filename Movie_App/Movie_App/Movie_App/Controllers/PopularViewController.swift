//
//  ViewController.swift
//  Movie_App
//
//  Created by Bahadir Alacan on 25.07.2022.
//

//moya
import UIKit
import CoreData

class PopularViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tabbarItem: UITabBarItem!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var movieCollectionView: UICollectionView! {
        didSet {
            movieCollectionView.dataSource = self
            movieCollectionView.delegate = self
            movieCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
            movieCollectionView.register(UINib(nibName: String(describing: MovieCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MovieCell.self))
            movieCollectionView.register(UINib(nibName: String(describing: InfoCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: InfoCell.self))
        }
    }
    
    let favouriteManager = FavouriteManager()
    var isSearchMovie = true
    var page: Int = 1
    var totalPage: Int = 0
    var searchPage: Int = 1
    var totalSearchPage: Int = 0
    var searchMovie: String = ""
    var searchController: Bool = false
    private var favouriteMovieList: [FavouriteMovie] = []
    private var movieList: [MovieResults] = [] {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    private var personList: [PersonResults] = [] {
        didSet {
            movieCollectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouriteMovieList = favouriteManager.getAllItems()
        NotificationCenter.default.addObserver(self, selector: #selector(manageFavourite(_:)), name: NSNotification.Name(rawValue: NotificationConstants.manageFavourite), object: nil)
        movieCollectionView.contentInset = UIEdgeInsets(top: 10, left: 3, bottom: 10, right: 3)
        searchTextField.delegate = self
        searchTextField.placeholder = StringConstants.searchFieldPlaceholder
        fetchPopularMovies()
        tabbarItem.title = StringConstants.tabbarPopular
    }
    
    @objc func manageFavourite(_ notification: NSNotification) {
            self.favouriteMovieList = favouriteManager.getAllItems()
            movieCollectionView.reloadData()
    }
    
    private func fetchPopularMovies() {
        showSpinner(onView: self.view)
        Network.shared.fetchData2(model: Movie.self) { result in
            switch result {
            case .success(let response):
                self.totalPage = response.total_pages ?? 0
                self.movieList = response.results ?? []
                self.removeSpinner()
            case .failure(let error):
                print(error)
            }
        }
    }
    private func fetchPerson() {
        Network.shared.fetchData2(with: NetworkConstants.personSearchingParameter, query: searchMovie, model: Person.self) { result in
            switch result {
            case .success(let response):
                self.totalSearchPage = response.total_pages ?? 0
                self.personList = response.results ?? []
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func segmentChange(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                isSearchMovie = true
                resetPage()
            case 1:
                isSearchMovie = false
                resetPage()
                fetchPerson()
                movieCollectionView.reloadData()
            default:
                break
            }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        searchTextField.resignFirstResponder()
        resetPage()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func resetPage() {
        movieCollectionView.setContentOffset(.zero, animated: false)
        searchMovie = ""
        searchTextField.text = ""
        searchController = false
        searchPage = 1
        page = 1
        fetchPopularMovies()
    }
    
    private func appendMovieWithPagination(page: Int) {
        if isSearchMovie {
            Network.shared.fetchData2(with: NetworkConstants.movieSearchingParameter, page: page, query: searchMovie, model: Movie.self) { result in
                switch result {
                case .success(let response):
                    self.movieList.append(contentsOf: response.results ?? [])
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            Network.shared.fetchData2(with: NetworkConstants.personSearchingParameter, page: page, query: searchMovie, model: Person.self) { result in
                switch result {
                case .success(let response):
                    self.personList.append(contentsOf: response.results ?? [])
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

// MARK: - Collection View Protocols
extension PopularViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0.1 {
            searchTextField.resignFirstResponder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searchMovie == "" && !isSearchMovie {
            return 0
        }
        return isSearchMovie ? movieList.count : personList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearchMovie {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCell.self), for: indexPath) as? MovieCell else {
                return UICollectionViewCell()
            }
            let movie = movieList[indexPath.row]
            cell.star.setImage(UIImage.init(systemName: ImageConstants.favouriteImage), for: .normal)
            if favouriteManager.isFavourite(movieID: movie.movieId ?? -1) {
                cell.star.setImage(UIImage.init(systemName: ImageConstants.filledFavouriteImage), for: .normal)
            }
            cell.index = indexPath
            cell.delegate = self
            cell.configure(movie: movie)
            return cell
        } else {
            guard let cell = movieCollectionView.dequeueReusableCell(withReuseIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell else {
                return UICollectionViewCell()
            }
            let person = personList[indexPath.row]
            cell.configure(image: person.profile_path ?? ImageConstants.placeholderActorImage, info: "", title: person.name ?? "")
            return cell
            
        }
    }
    //bunun başka metodu var
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
        let contentOffsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if contentOffsetY > contentHeight - height {
            if searchController {
                if searchPage < totalSearchPage {
                    searchPage += 1
                    appendMovieWithPagination(page: searchPage)
                }
            } else {
                if page < totalPage {
                    page += 1
                    appendMovieWithPagination(page: page)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearchMovie {
            guard let detailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: DetailViewController.self)) as? DetailViewController else {
                return
            }
            detailViewController.movie = self.movieList[indexPath.row]
            self.navigationController?.pushViewController(detailViewController, animated: true)
        } else {
            guard let castViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: String(describing: CastViewController.self)) as? CastViewController else {
                return
            }
            castViewController.id = self.personList[indexPath.row].id
            self.navigationController?.pushViewController(castViewController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2.1, height: UIScreen.main.bounds.height / 2)
    }
}

// MARK: - Text Field Protocol
extension PopularViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if searchTextField.text == "" {
            resetPage()
            return
        }
        var name = ""
        if ((searchTextField.text?.contains(" ")) != nil) {
            name = searchTextField.text?.replacingOccurrences(of: " ", with: "%20") ?? ""
        }
        searchController = true
        searchMovie = name
        if isSearchMovie {
            Network.shared.fetchData2(with: NetworkConstants.movieSearchingParameter, query: searchMovie, model: Movie.self) { result in
                switch result {
                case .success(let response):
                    self.totalSearchPage = response.total_pages ?? 0
                    self.movieList = response.results ?? []
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            fetchPerson()
        }
    }
}

// MARK: - Cell Manager Protocol
extension PopularViewController: CellManager {
    func manageFavourite(indx: Int) {
        
        
        
        
        
        let movie = movieList[indx]
        var index = 0
        for favMovie in favouriteMovieList {
            if favMovie.movieId == movie.movieId ?? -1 {
                favouriteManager.deleteItem(movie: favMovie)
                favouriteMovieList.remove(at: index)
                movieCollectionView.reloadData()
                NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationConstants.manageFavourite), object: nil, userInfo: nil)
                favouriteManager.saveContext()
                return
            }
            index = index + 1
        }
        let newFavMovie = favouriteManager.convertItem(movie: movie)
        favouriteMovieList.append(newFavMovie)
        favouriteManager.saveContext()
        movieCollectionView.reloadData()
        NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationConstants.manageFavourite), object: nil, userInfo: nil)
    }
}
