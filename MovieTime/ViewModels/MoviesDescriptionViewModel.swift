//
//  MoviesDescriptionViewModel.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 03/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import UIKit

class MoviesDescriptionViewModel: NSObject {

    func sendRating(rating: Float, movieID: Int, responseModel: @escaping (ServerResponse)) -> Void {
        ApiRequestManager.apiSharedManager.postApiCall(params: ["value": rating as AnyObject], url: userRatingURL(movieID: movieID), headers: ["Content-Type": "application/json;charset=utf-8" as AnyObject], responseObj: { (_, _, _) in
        })
    }
}
