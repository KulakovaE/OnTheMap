//
//  LoginResponse.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let username: String
    let phone: String
    let createdAt: String
    let updatedAt: String
    let objectId: String
    let sessionToken: String
}
