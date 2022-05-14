//
//  HomeViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home view Controller works!")
        initHomeView()
        navIfLoggedIn()
    }
    
    func initHomeView() {
        Style.styleFilledButton(signupButton)
        Style.styleHollowButton(loginButton)
    }
    
    func navIfLoggedIn() {
        let user = Auth.auth().currentUser
        if user != nil {
            print("Current user: ", user!.uid)
            self.navToMovie()
        } else {
            print("No user logged in.")
        }
    }
    
    @objc func navToMovie() {
        self.performSegue(withIdentifier: "homeToMovie", sender: nil)
    }
    
}
