//
//  UrlList.swift
//  MovieTime
//
//  Created by Shubham Kapoor on 02/01/19.
//  Copyright © 2019 Shubham Kapoor. All rights reserved.
//

import Foundation

let baseURL = "https://api.themoviedb.org/3/movie/"

let topRatedMoviesURL = URL(string: "\(baseURL)top_rated?api_key=f381b2ca5c59e33c296288b03a412294")
let moviesInTheaterURL = URL(string: "\(baseURL)now_playing?api_key=f381b2ca5c59e33c296288b03a412294")
let popularMoviesURL = URL(string: "\(baseURL)popular?api_key=f381b2ca5c59e33c296288b03a412294")
let upcomingMoviesURL = URL(string: "\(baseURL)upcoming?api_key=f381b2ca5c59e33c296288b03a412294")

func userRatingURL(movieID: Int) -> URL {
    return URL(string: "\(baseURL)\(movieID)/rating?api_key=f381b2ca5c59e33c296288b03a412294")!
}

func searchMovieURL(movieName: String) -> URL {
    let movie = movieName.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
    return URL(string: "https://api.themoviedb.org/3/search/movie?api_key=f381b2ca5c59e33c296288b03a412294&query=\(movie)")!
}

