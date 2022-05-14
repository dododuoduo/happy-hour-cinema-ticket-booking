//
//  SignupViewController.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 14/5/2022.
//

import Foundation
import UIKit
import FirebaseAuth


class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var db = DB()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Signup view Controller works!")
        initSignupView()
    }
    
    func initSignupView() {
        // hide the error label
        errorLabel.alpha = 0
        
        // style other elements in the signup view
        Style.styleTextField(firstNameField)
        Style.styleTextField(lastNameField)
        Style.styleTextField(emailField)
        Style.styleTextField(passwordField)
        Style.styleFilledButton(signupButton)
    }
    
    func showErrorMsg(msg: String) {
        self.errorLabel.text = msg
        self.errorLabel.textColor = .red
        self.errorLabel.alpha = 1
    }
    
    func showLoading() {
        self.errorLabel.text = "Creating account..."
        self.errorLabel.textColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
        self.errorLabel.alpha = 1
    }
    
    func showSuccessMsg() {
        self.errorLabel.text = "User creation success!"
        self.errorLabel.textColor = UIColor.init(red: 42/255, green: 157/255, blue: 143/255, alpha: 1)
        self.errorLabel.alpha = 1
    }
    
    @IBAction func onSignupTapped(_ sender: Any) {
        self.showLoading()
        
        let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstname = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        do {
            try AuthUtils.validateSignUpFields(firstname: firstname, lastname: lastname, email: email, password: password)
        } catch AuthError.emptyFieldError(message: let errMsg) {
            self.showErrorMsg(msg: errMsg)
            return
        } catch AuthError.weakPasswordError(message: let errMsg) {
            self.showErrorMsg(msg: errMsg)
            return
        } catch {
            self.showErrorMsg(msg: "Unexpected error!")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) {(result, err) in
            if err != nil {
                self.showErrorMsg(msg: "Cannot create user!")
                return
            }
            
            let uid = result!.user.uid
            
            self.db.setUserInfo(
                uid: uid,
                firstname: firstname,
                lastname: lastname,
                errorLabel: self.errorLabel
            )
            
            self.showSuccessMsg()
            self.navToMovie()
        }
    }
    
    @objc func navToMovie() {
        self.performSegue(withIdentifier: "signUpToMovie", sender: nil)
    }
}
