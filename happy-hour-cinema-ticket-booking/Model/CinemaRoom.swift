//
//  CinemaRoom.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 15/5/2022.
//

import Foundation
import UIKit

struct Pos {
    var x: Int
    var y: Int
}

class CinemaRoom {
//    var seats: [Seat]
    var seats: [Seat]
    var seatPos: [[Pos]]
    var superView: UIView
    var width: Int
    var height: Int
    let seatsRow: Int = 5
    let seatsCol: Int = 8
    let seatSize: Int = 27
    let seatGap: Int = 4
    var selectedSeats: [String] = []
    let reservedSeatsId: [String]
    let maxSeatNum: Int
    let seatsSelectedLabel: UILabel
    let selectMoreLabel: UILabel
    
    init (
        superView: UIView,
        reservedSeatsId: [String],
        maxSeatNum: Int,
        seatsSelectedLabel: UILabel,
        selectMoreLabel: UILabel
    ) {
        self.superView = superView
        self.reservedSeatsId = reservedSeatsId
        self.maxSeatNum = maxSeatNum
        self.seatsSelectedLabel = seatsSelectedLabel
        self.selectMoreLabel = selectMoreLabel
        self.seats = []
        self.seatPos = []
        self.width = Int(self.superView.frame.width)
        self.height = Int(self.superView.frame.height)
    }
    
    func markReservedSeats() {
        print("CinemaRoom - markReservedSeats: ", self.reservedSeatsId)
        for seatId in self.reservedSeatsId {
            for seat in seats {
                if seat.id == seatId {
                    seat.markAsReserved()
                }
            }
        }
    }
    
    func generateSeatPos() {
        for r in 0..<self.seatsRow + 1 {
            if r == 2 {
                continue
            }
            
            var posRow:[Pos] = []
            
            for c in 0..<self.seatsCol + 2 {
                if c == 2 || c == 7 || r == 2 {
                    continue
                }
                let seatX = c * (self.seatSize + self.seatGap)
                let seatY = r * (self.seatSize + self.seatGap)
                posRow.append(Pos(x: seatX, y: seatY))
            }
            
            self.seatPos.append(posRow)
        }
    }
    
    @IBAction func seatTapped(_ sender: Seat) {
        if (self.selectedSeats.count >= self.maxSeatNum) {
            return
        }
        let selectedSeatId = sender.selectSeat()
        self.selectedSeats.append(selectedSeatId)
        self.seatsSelectedLabel.text = "Seats selected: " + self.selectedSeats.joined(separator: ", ")
        let seatsLeft = self.maxSeatNum - self.selectedSeats.count
        if seatsLeft <= 0 {
            self.selectMoreLabel.text = "All set!"

        } else {
            self.selectMoreLabel.text = "Select \(seatsLeft) more to go"
        }
    }
    
    // generate a seat array
    @objc func generateSeats() {
        self.generateSeatPos()
        for r in 0..<self.seatPos.count {
            for c in 0..<self.seatPos[0].count {
                let pos = self.seatPos[r][c]
                let seatId = generateSeatId(r: r, c: c)
                let seat = Seat(x: pos.x, y: pos.y, size: self.seatSize, id: seatId)
                seat.addTarget(self, action: #selector(seatTapped(_:)), for: .touchUpInside)
                self.seats.append(seat)
            }
        }
    }
    
    // translate 2D coordinates of the seat to a 1D identifier
    func generateSeatId(r: Int, c: Int)-> String{
        var rowChar = ""
        let colChar = String(c)
        switch r {
        case 0:
            rowChar = "A"
        case 1:
            rowChar = "B"
        case 2:
            rowChar = "C"
        case 3:
            rowChar = "D"
        case 4:
            rowChar = "E"
        default:
            rowChar = "?"
        }
        return rowChar + colChar
    }
    
    func renderSeats() {
        self.generateSeats()
        self.markReservedSeats()
        
        // create a container for all seats
        let seatsContainerWidth = (self.seatSize + self.seatGap) * (self.seatsCol + 2) - self.seatGap
        let seatsContainerHeight = (self.seatSize + self.seatGap) * (self.seatsRow + 1) - self.seatGap
        let seatsWrapperView = UIView()
        seatsWrapperView.frame.size.width = CGFloat(seatsContainerWidth)
        seatsWrapperView.frame.size.height = CGFloat(seatsContainerHeight)
        
        // add all seats to the container
        for seat in self.seats {
            seatsWrapperView.addSubview(seat)
        }
        
        self.superView.addSubview(seatsWrapperView)
        
        // center the container inside the parent view
        seatsWrapperView.center = CGPoint(
            x: seatsWrapperView.superview!.bounds.width / 2.0,
            y: seatsWrapperView.superview!.bounds.height / 2.0
        )
        
//        print("Parent width: ", seatsWrapperView.superview!.bounds.width)
//        print("Parent height: ", seatsWrapperView.superview!.bounds.height)
//        print("Parent center: ", seatsWrapperView.center)
//
//        print("Child width: ", seatsWrapperView.frame.width)
//        print("Child height: ", seatsWrapperView.frame.height)
//        print("Child center: ", seatsWrapperView.center)
//
//        seatsWrapperView.backgroundColor = .brown
    }
    
}
