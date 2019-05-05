//
//  StudentLocation.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let mediaURL: String
    let firstName: String
    let longitude: Double
    let uniqueKey: String
    let latitude: Double
    let mapString: String
    let lastName: String
    let createdAt: String
    let updatedAt: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try container.decodeIfPresent(String.self, forKey: .objectId) ?? ""
        self.mediaURL = try container.decodeIfPresent(String.self, forKey: .mediaURL) ?? ""
        self.firstName = try container.decodeIfPresent(String.self, forKey: .firstName) ?? ""
        self.longitude = try container.decodeIfPresent(Double.self, forKey: .longitude) ?? 0
        self.uniqueKey = try container.decodeIfPresent(String.self, forKey: .uniqueKey) ?? ""
        self.latitude = try container.decodeIfPresent(Double.self, forKey: .latitude) ?? 0
        self.mapString = try container.decodeIfPresent(String.self, forKey: .mapString) ?? ""
        self.lastName = try container.decodeIfPresent(String.self, forKey: .lastName) ?? ""
        self.createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        self.updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
    }
}
