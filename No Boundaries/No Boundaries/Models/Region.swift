//
//  Region.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/29/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation

struct Region: Codable {
    var name: String
    var iso: String
    var center: CoordData
    var borders: [[CoordData]]
}

struct CoordData: Codable {
    var lat: Double
    var lon: Double
}
