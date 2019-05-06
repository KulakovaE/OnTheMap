//
//  StudentInformation.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-04.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import UIKit
import MapKit

class StudentAnnotationInfo: NSObject, MKAnnotation {
    var title: String?
    var subtitle: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
}

