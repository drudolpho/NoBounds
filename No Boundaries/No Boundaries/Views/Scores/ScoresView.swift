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
    
    @ObservedObject var regionVM: RegionViewModel
    @ObservedObject var networkController: NetworkController
    @Binding var navBarHidden : Bool
    @Binding var refreshScores: Bool
    
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
                MyScoresView(regionVM: self.regionVM, refreshScores: self.$refreshScores)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height / 4)
                    .cornerRadius(20)
                
            }.navigationBarTitle("Highscores")
                .onAppear() {
                    self.navBarHidden = false
            }
        }
    }
}

//struct ScoresView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoresView(networkController: NetworkController(), navBarHidden: false)
//    }
//}
