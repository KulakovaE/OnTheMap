//
//  FinishAddLocationViewController.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-06.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import MapKit

class FinishAddLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var finishButton: UIButton!
    
    var location: CLLocationCoordinate2D?
    var mediaUrl: URL?
    var searchLocationText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let location = location else { return }
        let myLocationAnnotation = StudentAnnotationInfo(title: searchLocationText, subtitle: nil, coordinate: location)
        mapView.addAnnotation(myLocationAnnotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StudentAnnotationInfo else { return nil }
        
        let identifier = "StudentInformation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    @IBAction func finishAddLocation(_ sender: Any) {
        guard let myLocation = location else { return }
        
        let myStudentInformation = StudentInformation(uniqueKey: UdacityClient.Auth.key,
                                                      firstName: UdacityClient.Auth.firstName,
                                                      lastName: UdacityClient.Auth.lastName,
                                                      mapString: searchLocationText ?? "",
                                                      mediaURL: mediaUrl?.absoluteString ?? "",
                                                      latitude: myLocation.latitude,
                                                      longitude: myLocation.longitude,
                                                      objectId: UdacityClient.Auth.objectId)
        if UdacityClient.Auth.objectId != "" {
            UdacityClient.updateStudentLocation(studentInformation: myStudentInformation, completion: handlePostStudentLocation(success:error:))
        } else {
            UdacityClient.postStudentLocation(studentInformation: myStudentInformation, completion: handlePostStudentLocation(success:error:))
        }
    }
    
    func handlePostStudentLocation(success: Bool, error: Error?){
        if success {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "goToOnTheMap", sender: nil)
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert(message: "Failed to send location. Try again.")
            }
        }
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}


