//
//  NetworkController.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/29/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import FirebaseDatabase

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
