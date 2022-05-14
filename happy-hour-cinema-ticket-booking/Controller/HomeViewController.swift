//
//  HomeViewController.swift
//  happy-hour-cinema-ticket-booking
//
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home view Controller works!")
        initHomeView()
    }
    
    func initHomeView() {
        Style.styleFilledButton(signupButton)
        Style.styleHollowButton(loginButton)
    }
}
