//
//  UserDataResponse.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-05.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
