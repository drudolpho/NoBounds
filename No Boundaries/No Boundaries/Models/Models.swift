//
//  Models.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/2/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation

struct StateData: Codable {
    var state: [SingleStateData]
}
struct SingleStateData: Codable {
    var point: [CoordData]
    var _name: String
    var _colour: String
}

struct CoordData: Codable {
    var _lat: String
    var _lng: String
}

struct USState {
    var name: String
    var borders: [CoordData]
}
