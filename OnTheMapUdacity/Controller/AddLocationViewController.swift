//
//  AddLocationViewController.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-05.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import MapKit


class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var linkTextField: UITextField!
    @IBOutlet var findLocation: UIButton!
    
    var locationText: String?
    var mediaUrl: URL?
    
    let spinner = SpinnerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationTextField.delegate = self
        linkTextField.delegate = self
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Add Location"
        setupBarButtonItems()
        setupHideKeyboardOnTap()
    }
    
    func setupBarButtonItems() {
        let cancelNavigationButton = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        cancelNavigationButton.tintColor = UIColor(red: 30/255, green: 180/255, blue: 226/255, alpha: 1)

        navigationItem.leftBarButtonItems = [cancelNavigationButton]
    }

    @objc func cancel(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let locationText = self.locationTextField.text, locationText != ""  else {
            showAlert(message: "Please fill location text.")
            return
        }
        
        guard let mediaUrlPath = self.linkTextField.text,
            let mediaUrl = URL(string: mediaUrlPath),
                UIApplication.shared.canOpenURL(mediaUrl)  else {
            showAlert(message: "Please fill valid URL.")
            return
        }
        
        self.locationText = locationText
        self.mediaUrl = mediaUrl
        
        handleGetCoordinate(from: locationText)
        
    }
    
    func handleGetCoordinate(from locationText: String) {
        showSpinner()
        getCoordinate(from: locationText) { (location, error) in
            if error != nil  || !CLLocationCoordinate2DIsValid(location) {
                DispatchQueue.main.async {
                    self.hideSpinner()
                    self.showAlert(message: "Could not find this location. Try again with more info.")
                }
            } else {
                self.hideSpinner()
                if let finishAddLocationVC = self.storyboard?.instantiateViewController(withIdentifier: "FinishAddLocationViewController") as? FinishAddLocationViewController {
                    finishAddLocationVC.location = location
                    finishAddLocationVC.searchLocationText = self.locationText
                    finishAddLocationVC.mediaUrl = self.mediaUrl
                    self.navigationController?.pushViewController(finishAddLocationVC, animated: true)
                }
            }
        }
    }

    func getCoordinate(from location: String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
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

extension AddLocationViewController {
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
