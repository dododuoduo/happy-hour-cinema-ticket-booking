//
//  DB.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 14/5/2022.
//

import Foundation
import UIKit
import Firebase

class DB {
    var userCollection: Firebase.CollectionReference
    var bookingCollection: Firebase.CollectionReference
    var reservedSeatsCollection: Firebase.CollectionReference
    
    init() {
        let db = Firestore.firestore()
        self.userCollection = db.collection("users")
        self.bookingCollection = db.collection("bookings")
        self.reservedSeatsCollection = db.collection("reservedSeats")
    }
    
    func setUserInfo(uid: String, firstname: String, lastname: String, errorLabel: UILabel) {
        self.userCollection.document(uid).setData([
            "uid": uid,
            "firstname": firstname,
            "lastname": lastname
        ]) { (error) in
            if error != nil {
                errorLabel.text = "Error: User info creation failed!"
                errorLabel.alpha = 1
            }
        }
    }
    
    func getFirstname(uid: String, _ completion:@escaping (_ firstname: String?) -> Void) {
        let userDocRef = userCollection.document(uid)
        
        userDocRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                completion(nil)
                return
            }
            
            guard let firstname = data["firstname"] as? String else {
                completion(nil)
                return
            }
            
            completion(firstname)
        }
    }
    
    func getReservedSeats(mid: String, _ completion:@escaping (_ reservedSeats: [String]) -> Void) {
        let movieDocRef = self.reservedSeatsCollection.document(mid)
        
        movieDocRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                completion([])
                print("getReservedSeats - no doc found, return []")
                return
            }
            
            guard let reservedSeats = data["reservedSeatsId"] as? [String] else {
                completion([])
                return
            }
            
            completion(reservedSeats)
        }
    }
    
    func updateReservedSeats(mid: String, reservedSeats: [String]) {
        let movieDocRef = self.reservedSeatsCollection.document(mid)
        
        movieDocRef.setData([
            "reservedSeatsId": reservedSeats
        ]) { (error) in
            if error != nil {
                print("Fail to update reserved seats")
            } else {
                print("Success: reserved seats updated")
            }
        }
    }
    
//    struct Booking {
//        let bid: String             // booking id
//        let uid: String             // user id
//        let mid: String             // movie id
//        let movieName: String
//        let numPeople: Int
//        let reservedSeats: [String]
//    }
    
    func addBooking(booking: Booking, _ completion:@escaping (_ bid: String?) -> Void) {
        let bookingRef = self.bookingCollection.document()
        let bid = bookingRef.documentID
        
        bookingRef.setData([
            "bid": bid,
            "uid": booking.uid,
            "mid": booking.mid,
            "movieName": booking.movieName,
            "numPeople": booking.numPeople,
            "reservedSeats": booking.reservedSeats
        ]) { (error) in
            guard error == nil else {
                print("addBooking - failed to add")
                completion(nil)
                return
            }
            
            print("addBooking - failed to add")
            completion(bid)
        }
    }
    
    func getBooking(bid: String, _ completion:@escaping (_ booking: Booking?) -> Void) {
        let bookingDocRef = self.bookingCollection.document(bid)
        
        bookingDocRef.getDocument { (document, error) in
            guard let data = document?.data(), error == nil else {
                completion(nil)
                print("getBooking - no doc found, return nil")
                return
            }

            guard let bid = data["bid"] as? String else {
              completion(nil)
              return
            }
            
            guard let uid = data["uid"] as? String else {
              completion(nil)
              return
            }
            
            guard let mid = data["mid"] as? String else {
              completion(nil)
              return
            }
            
            guard let movieName = data["movieName"] as? String else {
              completion(nil)
              return
            }
            
            guard let numPeople = data["numPeople"] as? Int else {
              completion(nil)
              return
            }
            
            guard let reservedSeats = data["reservedSeats"] as? [String] else {
              completion(nil)
              return
            }
            
            completion(Booking(
                bid: bid, uid: uid, mid: mid, movieName: movieName, numPeople: numPeople, reservedSeats: reservedSeats
            ))
        }
    }
    
    
}


