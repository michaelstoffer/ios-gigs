//
//  LoginViewController.swift
//  Gigs
//
//  Created by Michael Stoffer on 5/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

enum LoginType {
    case signUp
    case signIn
}

class LoginViewController: UIViewController {
    
    // MARK: - @IBOutlets and Properties
    @IBOutlet var signUpSignInSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpLogInButton: UIButton!
    
    var gigController: GigController!
    var loginType = LoginType.signUp
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.signUpLogInButton.backgroundColor = UIColor(hue: 190/360, saturation: 70/100, brightness: 80/100, alpha: 1)
        self.signUpLogInButton.tintColor = .white
        self.signUpLogInButton.layer.cornerRadius = 8.0
    }
    
    // MARK: - @IBActions and Methods
    @IBAction func signUpSignInTapped(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.loginType = .signUp
            self.signUpLogInButton.setTitle("Sign Up", for: .normal)
        } else {
            self.loginType = .signIn
            self.signUpLogInButton.setTitle("Sign In", for: .normal)
        }
    }
    
    @IBAction func signUpLoginButtonTapped(_ sender: UIButton) {
        guard let gigController = self.gigController else { return }
        
        if let username = self.usernameTextField.text, !username.isEmpty,
            let password = self.passwordTextField.text, !password.isEmpty {
            let user = User(username: username, password: password)
            
            if loginType == .signUp {
                gigController.signUp(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign up: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            let alertController = UIAlertController(title: "Sign Up Successful", message: "Now please log in.", preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(alertAction)
                            self.present(alertController, animated: true, completion: {
                                self.loginType = .signIn
                                self.signUpSignInSegmentedControl.selectedSegmentIndex = 1
                                self.signUpLogInButton.setTitle("Sign In", for: .normal)
                            })
                        }
                    }
                }
            } else {
                gigController.signIn(with: user) { (error) in
                    if let error = error {
                        NSLog("Error occurred during sign in: \(error)")
                    } else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        }
    }
}
