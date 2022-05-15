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
    
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MovieViewController works!")
        self.initMovieView()
    }
    
    func initMovieView() {
        Style.styleFilledButton(myTicketButton)
        Style.styleFilledButton(logoutButton)
        firstnameLabel.alpha = 0
        firstnameLabel.layer.backgroundColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1).cgColor
        firstnameLabel.layer.cornerRadius = 20
        firstnameLabel.textColor = .white
        self.renderUsername()
    }
    
    func renderUsername() {
        let user = Auth.auth().currentUser
        if user == nil {
            return
        }
        
        let uid = user!.uid
        self.db.getFirstname(uid: uid) { (firstname) in
            self.firstnameLabel.text = firstname
            self.firstnameLabel.alpha = 1
        }
    }
    
    @IBAction func onLogoutTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Cannot signout")
            return
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
