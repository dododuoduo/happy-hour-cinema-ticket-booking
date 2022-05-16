//
//  SeatsViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit
import FirebaseAuth

class SeatsViewController: UIViewController {
    
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var seatsSelectedLabel: UILabel!
    @IBOutlet weak var selectMoreLabel: UILabel!
    
    var movidId: String = "aaa"               // TODO: remove hardcoded String <"aaa">, receive movidId from previous controller
    var movieName: String = "Doctor Strange"  // TODO: remove hardcoded String <"Doctor Strange">, receive movieName from previous controller
    var maxSeatNum: Int = 4                   // TODO: remove hardcoded Int<4>, receive maxSeatNum (i.e. number of people) from previous controller
    
    var cinemaView: UIView?
    var room: CinemaRoom?
    var db = DB()
    var bookingId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SeatsViewController works!")
        initSeatsView()
        self.cinemaView = self.view!.viewWithTag(100)
        self.resetCinemaView()
        self.initCinema()
    }
    
    func initSeatsView() {
        self.seatsSelectedLabel.text = "Seats selected: None"
        self.selectMoreLabel.text = "Select \(self.maxSeatNum) more to go"
        self.screenLabel.layer.cornerRadius = 5
        self.screenLabel.layer.masksToBounds = true
        Style.styleFilledButton(self.confirmOrderButton)
    }
    
    func resetCinemaView() {
        for sv in self.cinemaView!.subviews {
            sv.removeFromSuperview()
        }
    }
    
    func initCinema() {
        self.db.getReservedSeats(mid: self.movidId) { (reservedSeatsId) in
            print("initCinema - reservedSeats: ", reservedSeatsId)
            self.room = CinemaRoom(
                superView: self.cinemaView!,
                reservedSeatsId: reservedSeatsId,
                maxSeatNum: self.maxSeatNum,
                seatsSelectedLabel: self.seatsSelectedLabel,
                selectMoreLabel: self.selectMoreLabel
            )
            self.room!.renderSeats()
        }
    }
    
    @IBAction func onConfirmOrderTapped(_ sender: Any) {
        if self.room == nil {
            return
        }
        
        if self.room!.selectedSeats.count < self.maxSeatNum {
            print("Select more seats!")
            return
        }
        
        // add the booking to the database
        let newSelectedSeats = self.room!.selectedSeats
        let uid = Auth.auth().currentUser!.uid
        let booking: Booking = Booking(
            bid: "",
            uid: uid,
            mid: self.movidId,
            movieName: self.movieName,
            numPeople: self.maxSeatNum,
            reservedSeats: newSelectedSeats
        )
        self.db.addBooking(booking: booking) { bid in
            // update reserved seats for the movie
            self.bookingId = bid
            let reservedSeats = self.room!.reservedSeatsId
            let allSeatsReserved = newSelectedSeats + reservedSeats
            self.db.updateReservedSeats(mid: self.movidId, reservedSeats: allSeatsReserved)
            self.navToOrderConfirmation()
        }
    }
    
    @objc func navToOrderConfirmation() {
        self.performSegue(withIdentifier: "seatsToOrderConfirmation", sender: nil)
    }
    
    // pass booking id to the order confirmation controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "seatsToOrderConfirmation") {
            if let destinationVC = segue.destination as? OrderConfirmationViewController {
                destinationVC.bid = self.bookingId
            }
        }
    }
}
