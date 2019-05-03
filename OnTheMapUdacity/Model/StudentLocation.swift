//
//  StudentLocation.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct StudentLocation: Codable {
    
    var objectId: String
    var uniqueKey: String?
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longtitude: Double
    var createdAt: String
    var updatedAt: Date
}
