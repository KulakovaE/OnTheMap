//
//  ViewController.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUp: UIButton!

    let spinner = SpinnerViewController()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailTextField.text = ""
        passwordTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        subscribeToKeyboardNotifications()
        setupHideKeyboardOnTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let urlString = "https://auth.udacity.com/sign-up"
        
        if let url = URL(string: urlString) {
            let vc = SFSafariViewController(url: url)
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        guard let username = emailTextField.text, let password = passwordTextField.text else {
            self.showAlert(message: "Please insert username and password.")
            return
        }
        showSpinner()
        UdacityClient.login(username: username, password: password, completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        if success {
            UdacityClient.getUserData(userId: UdacityClient.Auth.key, completion: handleUserDataResponse(success:error:))
        } else {
            hideSpinner()
            DispatchQueue.main.async {
                var errorMessage = "Something went wrong. Failed to login."
                if let udacityError = error as? UdacityError {
                    errorMessage = udacityError.message
                } else if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func handleUserDataResponse(success: Bool, error: Error?){
        if success {
            UdacityClient.getStudentLocation(uniqueKey: UdacityClient.Auth.key, completion: handleStudentLocationResponse(success:error:))
        } else {
            hideSpinner()
            DispatchQueue.main.async {
                var errorMessage = "Something went wrong. Failed to login."
                if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func handleStudentLocationResponse(success: Bool, error: Error?){
        if success {
            UdacityClient.getStudentLocations(limit: 100,completion: handleStudentLocationsResponse(success:error:))
        } else {
            hideSpinner()
            DispatchQueue.main.async {
                var errorMessage = "Something went wrong. Failed to login."
                if let error = error {
                    errorMessage = error.localizedDescription
                }
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func handleStudentLocationsResponse(success: Bool, error: Error?) {
        hideSpinner()
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToOnTheMap", sender: nil)
            }
        } else {
            var errorMessage = "Something went wrong. Failed to download student locations."
            if let error = error {
                errorMessage = error.localizedDescription
            }
            DispatchQueue.main.async {
                self.showAlert(message: errorMessage)
            }
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func showSpinner(){
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func hideSpinner(){
        DispatchQueue.main.async {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }
    
    
    
}

extension LoginViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}

extension LoginViewController { //keyboard related methods
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if emailTextField.isFirstResponder || passwordTextField.isFirstResponder {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object:  nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object:  nil)
    }
    
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
