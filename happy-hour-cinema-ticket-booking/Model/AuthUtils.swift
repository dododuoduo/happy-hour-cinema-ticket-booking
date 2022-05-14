//
//  AuthUtils.swift
//  happy-hour-cinema-ticket-booking
//
//  Created by Yihan Liu on 14/5/2022.
//

import Foundation

enum AuthError: Error {
    case emptyFieldError(message: String)
    case weakPasswordError(message: String)
}

class AuthUtils {

    static func validateSignUpFields(firstname: String, lastname: String, email: String, password: String) throws {
        if isSignUpFieldEmpty(firstname: firstname, lastname: lastname, email: email, password: password) {
            throw AuthError.emptyFieldError(message: "Error: Please fill in all fields.")
        }
        
        if isPasswordValid(password) {
            throw AuthError.weakPasswordError(message: "Error: Password too weak")
        }
    }
    
    static func isSignUpFieldEmpty(firstname: String, lastname: String, email: String, password: String)->Bool {
        if (firstname.isEmpty || lastname.isEmpty || email.isEmpty || password.isEmpty) {
            return true
        }
        
        return false
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func validateLoginFields(email: String, password: String) throws {
        if isLoginFieldEmpty(email: email, password: password) {
            throw AuthError.emptyFieldError(message: "Error: Please fill in all fields.")
        }
    }
    
    static func isLoginFieldEmpty(email: String, password: String)->Bool {
        if (email.isEmpty || password.isEmpty) {
            return true
        }
        
        return false
    }
}
