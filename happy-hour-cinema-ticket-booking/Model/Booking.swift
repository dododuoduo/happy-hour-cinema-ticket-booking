//
//  Booking.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 16/5/2022.
//

import Foundation

struct Booking {
    let bid: String             // booking id
    let uid: String             // user id
    let mid: String             // movie id
    let movieName: String
    let numPeople: Int
    let reservedSeats: [String]
}
