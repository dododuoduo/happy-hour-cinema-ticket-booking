//
//  Movie.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Xiaojie Hou on 20/5/2022.
//

import Foundation

struct Movie {
    var movieId: String?
    var movieName : String?
    var year: String?
    var movieDescription: String?
    var movieRating: String?
    init(movieId: String? = nil, movieName: String? = nil, year: String? = nil, movieDescription: String? = nil, movieRating: String? = nil) {
        self.movieId = movieId
        self.movieName = movieName
        self.year = year
        self.movieDescription = movieDescription
        self.movieRating = movieRating
    }
}

