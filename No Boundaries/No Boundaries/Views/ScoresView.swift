//
//  ScoresView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/20/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import FirebaseDatabase

struct ScoresView: View {
    
    @ObservedObject var networkController: NetworkController
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    Text("Global 🌎")
                        .font(.headline)
                        .padding(.leading, 30.0)
                    Spacer()
                }
                HighscoresView(networkController: self.networkController)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.5)
                    .cornerRadius(20)
                HStack {
                    Text("Local 📱")
                        .font(.headline)
                        .padding(.leading, 30.0)
                    Spacer()
                }
                MyScoresView()
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height / 4)
                    .cornerRadius(20)
            
            }
        }
//        .background(Color.init(UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)))
    }
}

struct ScoresView_Previews: PreviewProvider {
    static var previews: some View {
        ScoresView(networkController: NetworkController())
    }
}
