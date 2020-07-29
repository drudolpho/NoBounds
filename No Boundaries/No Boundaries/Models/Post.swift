//
//  Post.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/29/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import FirebaseDatabase

class Post: Codable, Identifiable {
    
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
    
    func submitToServer(reference: DatabaseReference, challenge: Challenge) {
        reference.child(challenge.rawValue).child(id).setValue(dictionaryRepresentation) { (error:Error?, ref:DatabaseReference) in
            if let error = error {
                print("Data could not be saved: \(error).")
                return
            } else {
                print("Data saved successfully!")
            }
        }
    }
}

struct UserScores: Codable, Identifiable {
    var id: String
    var time: Int
    var name: String
    var date: Date
}
