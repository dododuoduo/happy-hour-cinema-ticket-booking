//
//  LoginViewController.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 14/5/2022.
//

import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Login view Controller works!")
        initLoginView()
    }
    
    func initLoginView() {
        // hide error label
        errorLabel.alpha = 0
        
        // style other elements
        Style.styleTextField(emailField)
        Style.styleTextField(passwordField)
        Style.styleFilledButton(loginButton)
    }
    
    func showErrorMsg(msg: String) {
        self.errorLabel.text = msg
        self.errorLabel.textColor = .red
        self.errorLabel.alpha = 1
    }
    
    func showLoading() {
        self.errorLabel.text = "Loading..."
        self.errorLabel.textColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
        self.errorLabel.alpha = 1
    }
    
    func showSuccessMsg() {
        self.errorLabel.text = "Login success!"
        self.errorLabel.textColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
        self.errorLabel.alpha = 1
    }
    
    @IBAction func onLoginTapped(_ sender: Any) {
        showLoading()
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            try AuthUtils.validateLoginFields(email: email, password: password)
        } catch AuthError.emptyFieldError(message: let errMsg) {
            self.showErrorMsg(msg: errMsg)
            return
        } catch {
            self.showErrorMsg(msg: "Unexpected error!")
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) {(result, err) in
            if err != nil {
                self.showErrorMsg(msg: "Incorrect email or password!")
                return
            }

            let uid = result!.user.uid

            self.showSuccessMsg()
            print("Login user: ", uid)
            self.navToMovie()
        }
    }
    
    
//    @IBAction func onLoginTapped(_ sender: Any) throws {
//        showLoading()
//        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
//
//        do {
//            try AuthUtils.validateLoginFields(email: email, password: password)
//        } catch AuthError.emptyFieldError(message: let errMsg) {
//            self.showErrorMsg(msg: errMsg)
//            return
//        } catch {
//            self.showErrorMsg(msg: "Unexpected error!")
//            return
//        }
//
//        Auth.auth().signIn(withEmail: email, password: password) {(result, err) in
//            if err != nil {
//                self.showErrorMsg(msg: "Incorrect email or password!")
//                return
//            }
//
//            let uid = result!.user.uid
//
//            self.showSuccessMsg()
//            print("Login user: ", uid)
//            self.navToMovie()
//        }
//    }
    
    
    
    @objc func navToMovie() {
        self.performSegue(withIdentifier: "loginToMovie", sender: nil)
    }
}
