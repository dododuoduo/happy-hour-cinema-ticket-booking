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
    var ticketCollection: Firebase.CollectionReference
    
    init() {
        let db = Firestore.firestore()
        self.userCollection = db.collection("users")
        self.ticketCollection = db.collection("tickets")
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
}


