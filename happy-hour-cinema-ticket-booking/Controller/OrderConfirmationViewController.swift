//
//  OrderConfirmationViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit

class OrderConfirmationViewController: UIViewController {
    
    var bid: String?
    let db = DB()
    var booking: Booking?
    var firstname: String?
    
    // DO NOT modify this function
    override func viewDidLoad() {
        super.viewDidLoad()
        print("OrderConfirmationViewController works!")
        print("Bid: \(self.bid!)")
        self.db.getBooking(bid: self.bid!) { booking in
            self.booking = booking
            self.db.getFirstname(uid: booking!.uid) { firstname in
                self.firstname = firstname
                self.initOrderConfirmationView()
            }
        }
    }
    
    func initOrderConfirmationView() {
        print("Booking struct is ready: \(self.booking!)")
        print("Firstname is ready: \(self.firstname!)")
        // TODO: entry point of all your codes, firstname and booking object is ready!!
        
        
        
    }

}
