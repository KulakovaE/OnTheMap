//
//  TabBarController.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-04.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        navigationItem.title = "On the Map"
        
        setupBarButtonItems()
    }
    
    func setupBarButtonItems() {
        let logoutBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        let refreshBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        let addLocationBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addLocation))
        
        logoutBarButtonItem.tintColor = UIColor(red: 30/255, green: 180/255, blue: 226/255, alpha: 1)
        refreshBarButtonItem.tintColor = UIColor(red: 30/255, green: 180/255, blue: 226/255, alpha: 1)
        addLocationBarButtonItem.tintColor = UIColor(red: 30/255, green: 180/255, blue: 226/255, alpha: 1)
        
        navigationItem.leftBarButtonItems = [logoutBarButtonItem]
        navigationItem.rightBarButtonItems = [addLocationBarButtonItem, refreshBarButtonItem]
    }
    
    @objc func logout() {
        UdacityClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    @objc func refresh() {
        UdacityClient.getStudentLocations(limit: 100) { (result, error) in
            if result == true {
                if let mapViewController = self.selectedViewController as? MapViewController {
                    DispatchQueue.main.async {
                           mapViewController.loadMapData()
                    }
                } else if let tableViewController = self.selectedViewController as? TableViewController {
                    DispatchQueue.main.async {
                        tableViewController.loadStudentLocationData()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.showAlert(message: "Failed to refresh data! Try again.")
                }
            }
        }
    }
    
    @objc func addLocation(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "AddLocationViewController") as? AddLocationViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func handleLogoutResponse(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                 self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            showAlert(message: "Failed to Logout! Try again.")
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
}
