//
//  LoginRequest.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct LoginRequest: Codable {
    let udacity: LoginParameters
}
struct LoginParameters: Codable {
    let username: String
    let password: String
}
