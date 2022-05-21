//
//  OrderDetailsViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit

class OrderDetailsViewController: UIViewController {
    
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var movieDescriptionLabel: UITextView!
    @IBOutlet weak var ticketNumberDisplay: UILabel!
    @IBOutlet weak var removeOneTicketButton: UIButton!
    @IBOutlet weak var addOneTicketButton: UIButton!
    
    @IBOutlet weak var ourRateLabel: UIImageView!
    @IBOutlet weak var imdbRateLabel: UILabel!
    @IBOutlet weak var selectSeatsButton: UIButton!
    
    // input
    var movieId: String?
    var movieName: String?
    var moiveDescription: String?
    
    // output
    var numOfTicket: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderDetailsViewController works!")
        initOrderDetailsView()
    }
    
    func initOrderDetailsView() {
        Style.styleFilledButton(self.selectSeatsButton)
        Style.styleHollowButton(self.addOneTicketButton)
        Style.styleHollowButton(self.removeOneTicketButton)
        self.numOfTicket = 1
        self.ticketNumberDisplay.text = String(self.numOfTicket)
        self.movieNameLabel.text = self.movieName!
        self.movieDescriptionLabel.text = self.moiveDescription!
        
        let imdbRate = 7.3  //remove after add new element in database
        self.imdbRateLabel.text = "\(imdbRate)/10"  //imdb change to self.imdbRate
        let ourRate = 4
        self.ourRateLabel.image = UIImage(named: "rate\(ourRate)") //like imdb
        
        
    }
    
    @IBAction func onRemoveOneTicket(_ sender: Any) {
        if self.numOfTicket <= 1 {
            self.showAlert(msg: "Please order at least one ticket!")
            return
        }
        
        self.numOfTicket -= 1
        self.ticketNumberDisplay.text = String(self.numOfTicket)

    }
    
    @IBAction func onAddOneTicket(_ sender: Any) {
        if self.numOfTicket >= 4 {
            self.showAlert(msg: "Cannot order more than 4 tickets!")
            return
        }
        
        self.numOfTicket += 1
        self.ticketNumberDisplay.text = String(self.numOfTicket)
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func isValidTicketNumber(ticketNum: Int)-> Bool {
        if ticketNum <= 4 && ticketNum >= 1 {
            return true
        }
        return false
    }
    
    @IBAction func onSelectSeatsTapped(_ sender: Any) {
        guard isValidTicketNumber(ticketNum: self.numOfTicket) else {
            showAlert(msg: "Invalid ticket number! Valid range: 1-4")
            return
        }
        
        self.navToOrderConfirmation()
    }
    
    @objc func navToOrderConfirmation() {
        self.performSegue(withIdentifier: "orderToSeats", sender: nil)
    }
    
    // pass data to the seats view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "orderToSeats") {
            if let destinationVC = segue.destination as? SeatsViewController {
                destinationVC.movieName = self.movieName!
                destinationVC.movieId = self.movieId!
                destinationVC.maxSeatNum = self.numOfTicket
            }
        }
    }
    
}
