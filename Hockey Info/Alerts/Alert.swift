//
//  Alert.swift
//  Hockey Info
//
//  Created by Larry Burris on 1/26/19.
//  Copyright © 2019 Larry Burris. All rights reserved.
//
import Foundation
import UIKit

class Alert
{
    class func showBasic(title: String, message: String, vc: UIViewController)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
    }
}

/*
 
 @IBAction func loginButtonTapped(_ sender: UIButton) {
 
 do {
 try login()
 // Transition to next screen
 
 } catch LoginError.incompleteForm {
 Alert.showBasic(title: "Incomplete Form", message: "Please fill out both email and password fields", vc: self)
 } catch LoginError.invalidEmail {
 Alert.showBasic(title: "Invalid Email Format", message: "Please make sure you format your email correctly", vc: self)
 } catch LoginError.incorrectPasswordLength {
 Alert.showBasic(title: "Password Too Short", message: "Password should be at least 8 characters", vc: self)
 } catch {
 Alert.showBasic(title: "Unable To Login", message: "There was an error when attempting to login", vc: self)
 }
 
 }
 
 func login() throws {
 
 let email = emailTextField.text!
 let password = passwordTextField.text!
 
 if email.isEmpty || password.isEmpty {
 throw LoginError.incompleteForm
 }
 
 if !email.isValidEmail {
 throw LoginError.invalidEmail
 }
 
 if password.characters.count < 8 {
 throw LoginError.incorrectPasswordLength
 }
 
 // Pretend this is great code that logs in my user.
 // It really is amazing...
 }
 
 */
