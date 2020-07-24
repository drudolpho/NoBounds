//
//  MyScoresView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/20/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct MyScoresView: View {
    
    @ObservedObject var regionVM: RegionViewModel
    @Binding var refreshScores: Bool
    
    var scores: [UserScores] {
        if let data = UserDefaults.standard.value(forKey:"scores\(self.regionVM.challenge.rawValue)") as? Data {
            guard let scores = try? PropertyListDecoder().decode(Array<UserScores>.self, from: data) else { return [] }
            return scores
        } else {
            return []
        }
    }
    
    static let taskDateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d"
        return formatter
    }()
    
    var body: some View {
        List(scores.reversed()) { score in
            HStack {
                Text("\(score.date, formatter: Self.taskDateFormat)")
                Spacer()
                Text(score.name)
                Spacer()
                Text("\(score.time) sec")
            }
        }
    }
}

//struct MyScoresView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyScoresView()
//    }
//}


