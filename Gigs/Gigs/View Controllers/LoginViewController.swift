//
//  LoginViewController.swift
//  Gigs
//
//  Created by Michael Stoffer on 5/28/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - @IBOutlets and Properties
    @IBOutlet var signUpSignInSegmentedControl: UISegmentedControl!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signUpLogInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - @IBActions and Methods
    @IBAction func signUpSignInTapped(_ sender: UISegmentedControl) {
    }
    
    @IBAction func signUpLoginButtonTapped(_ sender: UIButton) {
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
