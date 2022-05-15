//
//  SeatsViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit

class SeatsViewController: UIViewController {
    
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var screenLabel: UILabel!
    @IBOutlet weak var seatsSelectedLabel: UILabel!
    @IBOutlet weak var selectMoreLabel: UILabel!
    
    var movidId: String = "aaa"
    var maxSeatNum: Int = 4
//    var reservedSeatsId: [String] = []
    var cinemaView: UIView?
    var room: CinemaRoom?
    var db = DB()
    
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
        // clear old seats
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
//        self.db.updateReservedSeats()
        if self.room != nil {
            let newSelectedSeats = self.room!.selectedSeats
            let reservedSeats = self.room!.reservedSeatsId
            let allSeatsReserved = newSelectedSeats + reservedSeats
            self.db.updateReservedSeats(mid: self.movidId, reservedSeats: allSeatsReserved)
        }
    }
    
    
}
