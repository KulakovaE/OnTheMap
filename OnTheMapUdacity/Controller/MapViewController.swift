//
//  MapViewController.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-04.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    var students: [StudentAnnotationInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadMapData()
    }
    
    func loadMapData(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        
        self.students = UdacityData.studentInformations?.compactMap({ student -> StudentAnnotationInfo? in
            return StudentAnnotationInfo(title: student.name,
                                      subtitle: student.mediaURL,
                                      coordinate: CLLocationCoordinate2DMake(student.latitude, student.longitude))
        })
        
        if let students = self.students {
            mapView.addAnnotations(students)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is StudentAnnotationInfo else { return nil }
        
        let identifier = "StudentInformation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let button = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let studentInformation = view.annotation as? StudentAnnotationInfo,
            let mediaUrlPath = studentInformation.subtitle,
            let mediaUrl = URL(string: mediaUrlPath),
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
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}

extension MapViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
}
