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
    
    var movidId: String = "aaa"
    var maxSeatNum: Int = 4
    var reservedSeatsId: [String] = []
    var cinemaView: UIView?
    var room: CinemaRoom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SeatsViewController works!")
        initSeatsView()
        self.cinemaView = self.view!.viewWithTag(100)
        self.resetCinemaView()
        self.initCinema()
    }
    
    func initSeatsView() {
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
    
    func getReservedSeats() {
        self.reservedSeatsId = ["A2", "A5"]
    }
    
    func initCinema() {
        self.getReservedSeats()
        self.room = CinemaRoom(superView: self.cinemaView!, reservedSeatsId: self.reservedSeatsId)
        self.room!.renderSeats()
    }
    
    
    
}
