//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit
import Kingfisher

enum ViewType: String {
    case grid = "grid"
    case list = "list"
}

class MoviesViewController: UIViewController {

    //    MARK:- IBOutlets
    @IBOutlet weak var serachMovieTextField: UITextField!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    @IBOutlet weak var viewTypeButton: UIButton!
    
    //    MARK:- Objects & Properties
    var movieView = String()
    let moviesViewModel = MoviewViewModel()
    var moviesModel = [TrendingMoviesModel]()
    
    //    MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        movieView = ViewType.list.rawValue
        getMovieList(url: topRatedMoviesURL!)
    }
    
    @IBAction func searchbuttonAction(_ sender: UIButton) {
        guard let movieToSerach = serachMovieTextField.text else {
            self.showAlert(withTitle: "Error", withMessage: "Enter some movie name to search.")
            return
        }
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
    private func getMovieList(url: URL) {
        moviesViewModel.getTrendingMovie(url: url, responseModel: { (response, success, error) in
            if success == true {
                self.moviesModel = response!
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        })
    }
}

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
            return listCell
        } else {
            gridCell.movieNameLabel.text = moviesModel[indexPath.row].title
            let rating = String(format: "%.1f", moviesModel[indexPath.row].rating ?? "nil")
            gridCell.movieRatingLabel.text = rating
            gridCell.releaseDateLabel.text = moviesModel[indexPath.row].releaseDate
            gridCell.movieImageView.kf.indicatorType = .activity
            return gridCell
        }
    }
}

extension MoviesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MovieDescriptionViewController") as! MovieDescriptionViewController
        vc.moviesModel = moviesModel[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

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
extension  UIViewController {
    
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
