//
//  Errors.swift
//  OnTheMapUdacity
//
//  Created by Darko Kulakov on 2019-05-04.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct UdacityError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
