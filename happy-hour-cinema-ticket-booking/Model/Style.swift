//
//  Style.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 14/5/2022.
//

import Foundation
import UIKit

class Style {
    
    static var textFieldColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
    static var buttonColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
    
    static func styleTextField(_ textfield:UITextField) {
        // Create the bottom line
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = self.textFieldColor.cgColor
        
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        // Filled rounded corner style
        button.backgroundColor = buttonColor
        button.layer.cornerRadius = 20
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        // Hollow rounded corner style
        button.backgroundColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 0)
        button.layer.borderWidth = 2
        button.layer.borderColor = buttonColor.cgColor
        button.layer.cornerRadius = 20
        button.tintColor = buttonColor
    }
}
