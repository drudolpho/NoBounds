//
//  Models.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/2/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import SwiftUI
import FirebaseDatabase

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

enum GameStatus {
    case before
    case during
    case lost
    case win
}

//For rounding corners

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

class USApost: Codable {
    
    let time: Int
    let name: String
    let id: String
    
    init(time: Int, name: String, id: String = UUID().uuidString) {
        self.time = time
        self.name = name
        self.id = id
    }
    
    convenience init?(dictionary: [String: Any]) {
        guard let time = dictionary["time"] as? Int,
            let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String else { return nil }

        self.init(time: time, name: name, id: id)
    }
    
    var dictionaryRepresentation: [String: Any] {
        return ["time": time, "name": name, "id": id]
      }
    
    func submitToServer(reference: DatabaseReference) {
        reference.child("USA").child(id).setValue(dictionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            } else {
                print("Data saved successfully!")
            }
        }
    }
}

