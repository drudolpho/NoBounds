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

class NetworkController: ObservableObject {
    var ref: DatabaseReference = Database.database().reference()
    @Published var posts: [Post] = []
    var myScores: [(Int, String, Date)] {
        get {
            return UserDefaults.standard.array(forKey: "scores") as? [(Int, String, Date)] ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "scores")
        }
    }
    
    func fetchPostsof(challenge: Challenge) {
        
        ref.child(challenge.rawValue).queryOrdered(byChild: "time").observe(.value) { (snapshot) in
            self.posts = []
            for snap in snapshot.children.allObjects as! [DataSnapshot] {
                if let postRep = snap.value as? [String: Any] {
                    if let post = Post(dictionary: postRep) {
                        self.posts.append(post)
                    }
                } else {
                    print("error fetching data")
                }
            }
        }
    }
}

//Saving scores to user defaults

struct UserScores: Codable, Identifiable {
    var id: String
    var time: Int
    var name: String
    var date: Date
}


enum Challenge: String {
    case USA = "United States"
    case Europe = "Europe"
    case Africa = "Africa"
    case World = "World"
    case Asia = "Asia"
    case SouthAmerica = "South America"
}


