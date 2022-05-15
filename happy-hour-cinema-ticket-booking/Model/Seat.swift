//
//  Seat.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 15/5/2022.
//

import Foundation
import UIKit

class Seat: UIButton {
    var id: String
    var size: Int
    
    required init(x: Int, y: Int, size: Int, id: String) {
        self.id = id
        self.size = size
        let buttonFrame = CGRect(x: x, y: y, width: self.size, height: self.size)
        super.init(frame: buttonFrame)
        self.backgroundColor = UIColor(red: 72/255, green: 219/255, blue: 87/255, alpha: 1)
        self.layer.cornerRadius = 5
        self.setTitle(self.id, for: .normal)
        self.setTitleColor(.black, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init is not implemented!")
    }
    
    public func selectSeat() -> String {
        self.backgroundColor = .blue
        self.isEnabled = false
        self.setTitleColor(.white, for: .normal)
        return self.id
    }
    
    public func markAsReserved() {
        self.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 50/255, alpha: 1)
        self.setTitleColor(.white, for: .normal)
        self.isEnabled = false
    }
}
