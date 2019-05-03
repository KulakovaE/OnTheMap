//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    //MARK: Outlets
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var signInWithFacebook: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else {
          return
        }
        
        ParseClient.login(username: username, password: password) { (result, error) in
            print(result)
            print(error)
        }
    }
    
}

