//
//  LoginResponse.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-03.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let id: String
    let expiration: String
}
