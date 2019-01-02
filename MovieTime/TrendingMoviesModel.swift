//
//  TrendingMoviesModel.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit

class TrendingMoviesModel: NSObject {

    var trendingMoviesModelObj = [TrendingMoviesModel]()
    var movieID: Int?
    var releaseDate: String?
    var imagePath: String?
    var adult: Bool?
    var rating: Float?
    var overview: String?
    var title: String?
    
    func fetchMovieData(data: [[String: AnyObject]]) -> [TrendingMoviesModel] {
        for movieData in data {
            let trendingModelObj = TrendingMoviesModel()
            trendingModelObj.movieID = movieData["id"] as? Int
            trendingModelObj.releaseDate =  movieData["release_date"] as? String
            trendingModelObj.imagePath = movieData["poster_path"] as? String
            trendingModelObj.adult = movieData["adult"] as? Bool
            trendingModelObj.rating = movieData["vote_average"] as? Float
            trendingModelObj.overview = movieData["overview"] as? String
            trendingModelObj.title = movieData["original_title"] as? String
            trendingMoviesModelObj.append(trendingModelObj)
        }
        return trendingMoviesModelObj
    }
}
