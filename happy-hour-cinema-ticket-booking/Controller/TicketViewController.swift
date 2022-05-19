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
    
    var scrollView: UIScrollView = UIScrollView()
    var scrollViewContainer: UIStackView = UIStackView()
     
    var bookings: [Booking] = []
    let db = DB()
    let uid: String = Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TicketViewController works!")
        
        self.db.getBookingByUid(uid: self.uid) { bookings in
            self.bookings = bookings
            self.initTicketView()
        }
    }
    
    func initTicketView() {
        // Uid and bookings are ready to use
        // If no booking for the user, the bookings array is empty: []
        self.initScrollView()
        self.initScrollViewContainer()
        self.initScrollViewItems()
        
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        // this is important for scrolling
        scrollViewContainer.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    
    func initScrollView() {
        for sv in self.scrollView.subviews {
            sv.removeFromSuperview()
        }
        
        self.scrollView = UIScrollView()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.isScrollEnabled = true
        self.view.addSubview(scrollView)
    }
    
    
    func initScrollViewContainer() {
        self.scrollViewContainer = UIStackView()
        self.scrollViewContainer.axis = .vertical
        self.scrollViewContainer.spacing = 10
        self.scrollViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.scrollView.addSubview(self.scrollViewContainer)
    }
    
    
    func initScrollViewItems() {
        if self.bookings.isEmpty {
            // an idicator of no booking records found
            let itemView = UIStackView()
            itemView.axis = .vertical
            itemView.translatesAutoresizingMaskIntoConstraints = false
            let emptyBookingLabel = UILabel()
            emptyBookingLabel.text = "No booking record"
            emptyBookingLabel.sizeToFit()
            emptyBookingLabel.textAlignment = .center
            emptyBookingLabel.textColor = .red
            itemView.addArrangedSubview(emptyBookingLabel)
            self.scrollViewContainer.addArrangedSubview(itemView)
            return
        }
        
        for (i, booking) in bookings.enumerated() {
            print("Index: \(i), booking: \(booking)")
            let itemView = self.generateBookingItemView(booking: booking)
            self.scrollViewContainer.addArrangedSubview(itemView)
        }
    }
    
    func generateBookingItemView(booking: Booking) -> UIStackView {
        let itemView = UIStackView()
        itemView.spacing = 5
        itemView.axis = .vertical
        itemView.translatesAutoresizingMaskIntoConstraints = false
        let bidLabel = UILabel()
        bidLabel.text = "Booking ID: \(booking.bid)"
        bidLabel.sizeToFit()
        let movieNameLabel = UILabel()
        movieNameLabel.text = "Movie: \(booking.movieName)"
        movieNameLabel.sizeToFit()
        let seatsLabel = UILabel()
        let seatsStr = booking.reservedSeats.joined(separator: ", ")
        seatsLabel.text = "Seats: \(seatsStr)"
        seatsLabel.sizeToFit()
        let cancelBookingButton = UIButton()
        cancelBookingButton.setTitle("Cancel booking", for: .normal)
        Style.styleFilledButton(cancelBookingButton)
        cancelBookingButton.layer.cornerRadius = 5
        cancelBookingButton.layer.name = booking.bid
        cancelBookingButton.addTarget(self, action: #selector(onCancelBookingTapped(_:)), for: .touchUpInside)
        itemView.addArrangedSubview(bidLabel)
        itemView.addArrangedSubview(movieNameLabel)
        itemView.addArrangedSubview(seatsLabel)
        itemView.addArrangedSubview(cancelBookingButton)
        
        return itemView
    }
    
    @IBAction func onCancelBookingTapped(_ sender: UIButton) {
        let bidToBeCanceled: String = sender.layer.name!
        print("Cancel booking tapped: \(bidToBeCanceled)")
        sender.setTitle("Cancelling...", for: .normal)
        self.removeBooking(bidToRemove: bidToBeCanceled)
    }
    
    
    // TODO: Use this function to remove a booking record from database.
    // NOTE: self.bookings will be updated automatically, if success
    func removeBooking(bidToRemove: String) {
        guard self.bookings.count > 0 else {
            print("No booking to remove")
            return
        }
        
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
    
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Success", message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
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
                // IMPORTANT:  reload page after a booking record is removed
                /*******************/
                if success {
                    self.showAlert(msg: "Booking Removed!")
                    self.viewDidLoad()
                }
            })
        }
    }
}
