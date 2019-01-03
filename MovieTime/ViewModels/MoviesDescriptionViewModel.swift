//
//  MoviesDescriptionViewModel.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 03/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit

class MoviesDescriptionViewModel: NSObject {

    func getTrendingMovie(rating: Float, movieID: Int, responseModel: @escaping (ServerResponse)) -> Void {
        ApiRequestManager.apiSharedManager.postApiCall(params: ["value": rating as AnyObject], url: userRatingURL(movieID: movieID), headers: ["Content-Type": "application/json;charset=utf-8" as AnyObject], responseObj: { (response, success, error) in
            print(response!)
            if success == true {
                print(response!)
//                if let data = response as? [String: AnyObject] {
////                    if let movieResults = data["results"] as? [[String: AnyObject]] {
////                        responseModel(response, true, nil)
////                    }
//                }
            } else {
                print(error?.localizedDescription ?? "Some thing went wrong")
            }
        })
    }
}
