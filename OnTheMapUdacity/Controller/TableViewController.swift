//
//  TableViewController.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-05.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    var studentLocations = [StudentInformation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStudentLocationData()
    }
    
    func loadStudentLocationData(){
        if let studentLocations = UdacityData.studentInformations{
            self.studentLocations = studentLocations
            self.tableView.reloadData()
        }
        
     
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentLocations.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OnTheMapTableViewCell", for: indexPath)
        if let cell = cell as? OnTheMapTableViewCell {
            let studentLocation = self.studentLocations[indexPath.row]
            cell.studentName.text = studentLocation.name
            cell.studentLink.text = studentLocation.mediaURL
        }
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let studentLocation = self.studentLocations[indexPath.row]
        guard let mediaUrl = URL(string: studentLocation.mediaURL),
            UIApplication.shared.canOpenURL(mediaUrl) else {
                DispatchQueue.main.async {
                    self.showAlert(message: "This URL is not valid!")
                }
                return
        }
        
        let vc = SFSafariViewController(url: mediaUrl)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

}
extension TableViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
