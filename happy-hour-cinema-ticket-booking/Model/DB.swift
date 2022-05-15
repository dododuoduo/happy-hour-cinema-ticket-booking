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
    var movieSeatsCollection: Firebase.CollectionReference
    
    init() {
        let db = Firestore.firestore()
        self.userCollection = db.collection("users")
        self.bookingCollection = db.collection("bookings")
        self.movieSeatsCollection = db.collection("movieSeats")
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
    
    
}


