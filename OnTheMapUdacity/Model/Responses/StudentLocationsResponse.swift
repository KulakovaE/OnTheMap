//
//  GetStudentLocationsResponse.swift
//  OnTheMapUdacity
//
//  Created by Elena Kulakova on 2019-05-04.
//  Copyright © 2019 Elena Kulakova. All rights reserved.
//

import Foundation

struct StudentLocationsResponse: Codable {
    let results: [StudentInformation]
}
