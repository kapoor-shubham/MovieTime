//
//  MoviewViewModel.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit

typealias movieResponseModel = ( _: [TrendingMoviesModel]?, _: Bool, _: Error?) -> Void

class MoviewViewModel: NSObject {
    
    let movieModel = TrendingMoviesModel()
    
    func getTrendingMovie(responseModel: @escaping (movieResponseModel)) -> Void {
        ApiRequestManager.apiSharedManager.getApiCall(url: topRatedMoviesURL!, headers: ["language": "en-US", "page": "1"], responseObj: { (response, success, error) in
            print(response!)
            if success == true {
                if let data = response as? [String: AnyObject] {
                    if let movieResults = data["results"] as? [[String: AnyObject]] {
                        responseModel(self.movieModel.fetchMovieData(data: movieResults), true, nil)
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Some thing went wrong")
            }
        })
    }
}
