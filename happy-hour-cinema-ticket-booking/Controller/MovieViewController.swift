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
    
    @IBOutlet weak var doctorStrangeButton: UIButton!
    @IBOutlet weak var sonicButton: UIButton!
    
    var selectedMovieId: String?
    var selectedMovieName: String?
    var selectedMovieDescription: String?
    
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
    
    @IBAction func onDoctorStrangeTapped(_ sender: Any) {
        self.selectedMovieId = "doctor-strange-id"
        self.selectedMovieName = "Doctor Strange in the Multiverse of Madness"
        self.selectedMovieDescription = "In Marvel Studios’ Doctor Strange in the Multiverse of Madness, the MCU unlocks the Multiverse and pushes its boundaries further than ever before. Journey into the unknown with Doctor Strange traverses the mind-bending and dangerous alternate realities of the Multiverse to confront a mysterious new adversary."
        self.navToOrderDetails()
    }
    
    @IBAction func onSonicTapped(_ sender: Any) {
        self.selectedMovieId = "sonic-id"
        self.selectedMovieName = "Sonic the Hedgehog 2"
        self.selectedMovieDescription = "The world’s favorite blue hedgehog is back for a next-level adventure in SONIC THE HEDGEHOG 2. After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero. His test comes when Dr. Robotnik returns, this time with a new partner, Knuckles, in search for an emerald that has the power to destroy civilizations. "
        self.navToOrderDetails()
    }
    
    @objc func navToOrderDetails() {
        self.performSegue(withIdentifier: "movieToOrderDetails", sender: nil)
    }
    
    // pass booking id to the order details controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "movieToOrderDetails") {
            if let destinationVC = segue.destination as? OrderDetailsViewController {
                destinationVC.movieId = self.selectedMovieId
                destinationVC.movieName = self.selectedMovieName
                destinationVC.moiveDescription = self.selectedMovieDescription
            }
        }
    }
    
}
