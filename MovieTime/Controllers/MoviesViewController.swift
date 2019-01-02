//
//  MoviesViewController.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit

enum ViewType: String {
    case grid = "grid"
    case list = "list"
}

class MoviesViewController: UIViewController {

    //    MARK:- IBOutlets
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
        getMovieList()
    }
    
    //    MARK:- IBActions
    @IBAction func viewTypeButtonAction(_ sender: UIButton) {
        if movieView == ViewType.list.rawValue {
            movieView = ViewType.grid.rawValue
            viewTypeButton.imageView?.image = UIImage(named: "grid")
        } else {
            movieView = ViewType.list.rawValue
            viewTypeButton.imageView?.image = UIImage(named: "list")
        }
        moviesCollectionView.reloadData()
    }
    
    func getMovieList() {
        moviesViewModel.getTrendingMovie(responseModel: { (response, success, error) in
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
            return listCell
        } else {
            gridCell.movieNameLabel.text = moviesModel[indexPath.row].title
            return gridCell
        }
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
