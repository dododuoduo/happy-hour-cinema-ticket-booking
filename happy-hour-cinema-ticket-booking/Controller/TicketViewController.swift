//
//  TicketViewController.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 13/5/2022.
//

import Foundation
import UIKit
import FirebaseAuth

class TicketViewController: UIViewController {
     
    var bookings: [Booking] = []
    let db = DB()
    let uid: String = Auth.auth().currentUser!.uid
    
    // TODO: remove this button, ths button is just for test
    @IBOutlet weak var testButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicketViewController works!")
        
        // a demo of how to get all bookings (for the current user) from the database
        self.db.getBookingByUid(uid: self.uid) { bookings in
            self.bookings = bookings
            // if you want to do something RIGHT AFTER update bookings (e.g. make a function call to initTicketView())
            // you should add code INSIDE the <{bookings in ... }> BLOCK:
            self.initTicketView()
        }
    }
    
    
    // TODO: this is an entry point of all your code, add your code to this function
    func initTicketView() {
        // Uid and bookings are ready to use
        // If no booking for the user, the bookings array is empty: []
        print("Uid: \(self.uid)")
        print("Bookings: \(self.bookings)")

        
    }
    
    // TODO: Use this function to remove a booking record from database.
    // NOTE: self.bookings will be updated automatically, if success
    func removeBooking(bidToRemove: String) {
        self.db.removeBookingByBid(bid: bidToRemove) { success in
            guard success else {
                print("ticketViewController - removeBooking - failed")
                return
            }
            // we need to remove seats reserved by the user from the database
            self.removeSeats(bid: bidToRemove)
        }
    }
    
    
    // TODO: Remove this function. This is a demo using test button and removeBooking() func to remove the first booking record
    @IBAction func onTestButtonTapped(_ sender: Any) {
        guard self.bookings.count > 0 else {
            print("No booking to remove")
            return
        }
        
        self.removeBooking(bidToRemove: self.bookings[0].bid)
        
    }
    
    
    /*******************/
    // Danger Zone: DO NOT use this method, DO NOT modify
    /*******************/
    func removeSeats(bid: String) {
        var bookingToRemove: Booking?
        
        for booking in self.bookings {
            if booking.bid == bid {
                bookingToRemove = booking
            }
        }
        
        guard bookingToRemove != nil else {
            print("ticketViewController - no booking to remove")
            return
        }
        
        let mid = bookingToRemove!.mid
        let seatsToRemove = bookingToRemove!.reservedSeats
        self.db.getReservedSeats(mid: mid) { reservedSeats in
            var newReservedSeats: [String] = []
            for rs in reservedSeats {
                if !seatsToRemove.contains(rs) {
                    newReservedSeats.append(rs)
                }
            }
            self.db.updateReservedSeats(mid: mid, reservedSeats: newReservedSeats, { success in
                /*******************/
                // IMPORTANT:  update self.bookings after a booking record is removed
                /*******************/
                if success {
                    self.db.getBookingByUid(uid: self.uid) { bookings in
                        self.bookings = bookings
                        print("Booking removed, current bookings: \(self.bookings)")
                    }
                }
            })
        }
    }
}
