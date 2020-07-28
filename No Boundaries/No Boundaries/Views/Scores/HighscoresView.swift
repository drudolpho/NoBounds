//
//  HighscoresView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/20/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct HighscoresView: View {
    
    @ObservedObject var networkController: NetworkController
    
    var body: some View {
        let withIndex = networkController.posts.enumerated().map({ $0 })
        return List(withIndex, id: \.element.id) { index, post in
            HStack {
                Text("\(index + 1).")
                Spacer()
                Text("\(post.name) \(self.getRankemoji(index: index))")
             
                Spacer()
                Text("\(self.formatTime(time: post.time))")
            }
        }
    }
    
    func formatTime(time: Int) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%01i:%02i", minutes, seconds)
    }
    
    func getRankemoji(index: Int) -> String {
        if index == 0 {
            return "👑"
        } else if index == 1 {
            return "🥈"
        } else if index == 2 {
            return "🥉"
//        } else if 3...9 ~= index {
//            return "🎗"
        } else {
            return ""
        }
    }
}

struct HighscoresView_Previews: PreviewProvider {
    static var previews: some View {
        HighscoresView(networkController: NetworkController())
    }
}
