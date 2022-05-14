//
//  MovieViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit
import FirebaseAuth

class MovieViewController: UIViewController {
    
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var myTicketButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MovieViewController works!")
        self.initMovieView()
    }
    
    func initMovieView() {
        Style.styleFilledButton(myTicketButton)
        Style.styleFilledButton(logoutButton)
    }
    
    func renderUserName() {
        let user = Auth.auth().currentUser
        if user == nil {
            return
        }
        
        let uid = user!.uid
        firstnameLabel.text = uid
    }
}
