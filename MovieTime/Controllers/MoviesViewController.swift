//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

enum ViewType: String {
    case grid = "grid"
    case list = "list"
}

class MoviesViewController: UIViewController, NVActivityIndicatorViewable {

    //    MARK:- IBOutlets
    @IBOutlet weak var serachMovieTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var viewTypeButton: UIButton!
    @IBOutlet weak var filterTableView: UITableView!
    
    //    MARK:- Objects & Properties
    var movieView = String()
    let moviesViewModel = MoviewViewModel()
    var moviesModel = [TrendingMoviesModel]()
    var filterList = ["In Theaters", "Popular", "Top Rated", "Upcoming"]
    var selectedFilter = String()
    var isSearched = Bool()
    
    //    MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewUIUpdate()
        movieView = ViewType.list.rawValue
        getMovieList(url: moviesInTheaterURL!)
    }
    
    @IBAction func filterButtonAction(_ sender: UIButton) {
        if filterTableView.isHidden == true {
            filterTableView.isHidden = false
        } else {
            filterTableView.isHidden = true
        }
    }
    
    @IBAction func searchbuttonAction(_ sender: UIButton) {
        guard let movieToSerach = serachMovieTextField.text else {
            self.showAlert(withTitle: "Error", withMessage: "Enter some movie name to search.")
            return
        }
        isSearched = true
        serachMovieTextField.resignFirstResponder()
        deleteImageCatche()
        getMovieList(url: searchMovieURL(movieName: movieToSerach))
    }
    
    //    MARK:- IBActions
    @IBAction func viewTypeButtonAction(_ sender: UIButton) {
        if movieView == ViewType.list.rawValue {
            movieView = ViewType.grid.rawValue
            viewTypeButton.setImage(UIImage(named: "grid"), for: .normal)
        } else {
            movieView = ViewType.list.rawValue
            viewTypeButton.setImage(UIImage(named: "list"), for: .normal)
        }
        moviesCollectionView.reloadData()
    }
    
    //    MARK:- Private Helper Methods

    /** Initial UIView Update */
    private func viewUIUpdate() {
        filterTableView.layer.borderColor = UIColor(red: 226/255, green: 150/255, blue: 32/255, alpha: 1.0).cgColor
        filterTableView.layer.borderWidth = 2.0
        selectedFilter = "In Theaters"
        selectedFilter = selectedFilter.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    /** Calls API and update movies List */
    private func getMovieList(url: URL) {
        startAnimating()
        moviesViewModel.getTrendingMovie(url: url, responseModel: { (response, success, error) in
            self.stopAnimating()
            if success == true {
                self.moviesModel = response!
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        })
    }
}

// MARK:- TextField Delegate
extension MoviesViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != nil {
            searchbuttonAction(UIButton())
        }
        return true
    }
}

// MARK:- TableView DataSource
extension MoviesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell") as! FilterTableViewCell
        cell.textLabel!.text = filterList[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}

// MARK:- TableView Delegate
extension MoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        filterTableView.isHidden = true
        var url: URL?
        switch indexPath.row {
        case 0:
            url = moviesInTheaterURL
        case 1:
            url = popularMoviesURL
        case 2:
            url = topRatedMoviesURL
        case 3:
            url = upcomingMoviesURL
        default: url = topRatedMoviesURL
        }
        if isSearched == true {
            isSearched = false
            deleteImageCatche()
            serachMovieTextField.text = nil
            serachMovieTextField.resignFirstResponder()
        }
        getMovieList(url: url!)
        selectedFilter = filterList[indexPath.row]
        selectedFilter = selectedFilter.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
}

// MARK:- CollectionView DataSource
extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let gridCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridViewCell", for: indexPath) as! GridViewCell
        let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        
        if movieView == ViewType.list.rawValue {
            listCell.movieNameLabel.text = moviesModel[indexPath.row].title
            let rating = String(format: "%.1f", moviesModel[indexPath.row].rating ?? "nil")
            listCell.movieRatingLabel.text = rating
            listCell.releaseDateLabel.text = moviesModel[indexPath.row].releaseDate
            listCell.movieImageView.kf.indicatorType = .activity
            if let imagePath = moviesModel[indexPath.row].imagePath {
                let url = URL(string: "http://image.tmdb.org/t/p/original"+imagePath)
                let catcheKey = "key-\(selectedFilter)\(indexPath.row)"
                let resource = ImageResource(downloadURL: url!, cacheKey: catcheKey)
                listCell.movieImageView.kf.setImage(with: resource)
            }
            return listCell
        } else {
            gridCell.movieNameLabel.text = moviesModel[indexPath.row].title
            let rating = String(format: "%.1f", moviesModel[indexPath.row].rating ?? "nil")
            gridCell.movieRatingLabel.text = rating
            gridCell.releaseDateLabel.text = moviesModel[indexPath.row].releaseDate
            gridCell.movieImageView.kf.indicatorType = .activity
            if let imagePath = moviesModel[indexPath.row].imagePath {
                let url = URL(string: "http://image.tmdb.org/t/p/original"+imagePath)
                let catcheKey = "key-\(selectedFilter)\(indexPath.row)"
                let resource = ImageResource(downloadURL: url!, cacheKey: catcheKey)
                gridCell.movieImageView.kf.setImage(with: resource)
            }
            return gridCell
        }
    }
}

// MARK:- CollectionView Delegate
extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDescriptionViewController") as! MovieDescriptionViewController
        var resource: ImageResource?
        if let imagePath = moviesModel[indexPath.row].imagePath {
            let url = URL(string: "http://image.tmdb.org/t/p/original"+imagePath)
            let catcheKey = "key-\(selectedFilter)\(indexPath.row)"
            resource = ImageResource(downloadURL: url!, cacheKey: catcheKey)
        }
        vc.resource = resource
        vc.moviesModel = moviesModel[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK:- CollectionView FlowLayout Delegate
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if movieView == ViewType.list.rawValue {
            return CGSize(width: moviesCollectionView.frame.width, height: 70)
        } else {
            let cellWidth = (moviesCollectionView.frame.width/2)
            return CGSize(width: cellWidth-10, height: cellWidth+60)
        }
    }
}

// MARK:- Extension for Alert View
extension UIViewController {
    
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}


//MARK:- Delete Image Catche
fileprivate func deleteImageCatche() {
    KingfisherManager.shared.cache.clearMemoryCache()
    KingfisherManager.shared.cache.clearDiskCache()
}
