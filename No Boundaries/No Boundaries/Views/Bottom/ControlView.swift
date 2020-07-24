//
//  ControlView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/7/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    
    @ObservedObject var regionVM: RegionViewModel
    @Binding var time: Int
    @Binding var bottomSheetShown: Bool
    @Binding var gameMode: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    
                    if self.regionVM.gameStatus == .during {
                        
                        Text(self.regionVM.promptedRegion?.name ?? "")
                            
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.regionVM.promptedRegion?.name ?? "")
                        
                        Spacer()
                        Text("\(self.time)")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding([.leading])
                            .transition(.opacity)
                            .id("\(self.time)")
                            .onReceive(self.timer) { _ in
                                if self.time < 999 {
                                    self.time += 1
                                }
                        }
                        Text("sec")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding(.trailing)
                        
                    } else if self.regionVM.gameStatus == .before {
                        Text("\(self.regionVM.challenge.rawValue)")
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.regionVM.challenge.rawValue)
                        Spacer()
                        Button(action: {
                            self.nextChallenge()
                            self.regionVM.resetGameData()
                        }) {
                            Text("Next")
                                .font(.headline)
                        }
//                        Text("\(UserDefaults.standard.integer(forKey: "score"))")
//                            .foregroundColor(.gray)
//                            .font(.headline)
//                            .padding([.leading])
//                        Text("sec")
//                            .foregroundColor(.gray)
//                            .font(.headline)
//                            .padding(.trailing)
                        
                    } else if self.regionVM.gameStatus == .lost {
                        Text("Game Over")
                            .bold()
                            .font(.title)
                        Spacer()
                        Text("\(self.regionVM.scoredRegions)/50 States")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding([.leading, .trailing])
                        
                    } else if self.regionVM.gameStatus == .win {
                        Text(self.regionVM.promptedRegion?.name ?? "")
                            
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.regionVM.promptedRegion?.name ?? "")
                        
                        Spacer()
                        Text("\(self.regionVM.getSetScore(time: self.time, mode: self.gameMode))")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding([.leading])
                            
                        Text("sec")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding(.trailing)
                    }
                }.padding(.horizontal, 35.0)
                
                Button(action: self.buttonTapped) {
                    Text(self.regionVM.getButtonText())
                        .font(.title)
                        .fontWeight(.medium)
                        .frame(width: geometry.size.width/1.2, height: geometry.size.height/3.5)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 0)
                        .transition(.opacity)
                        .id(self.regionVM.getButtonText())
                }.padding(.top, 20.0)
            }
        }
    }
    
    func nextChallenge() {
        switch self.regionVM.challenge {
        case .USA:
            self.regionVM.challenge = .World
        case .Europe:
            return
        case .Africa:
            return
        case .World:
            self.regionVM.challenge = .USA
        case .Asia:
            return
        case .SouthAmerica:
            return
        }
    }
    
    func resetTimer() {
        time = 0
    }
    
    func buttonTapped() {
        if regionVM.gameStatus == .before {
            self.bottomSheetShown = false
            regionVM.setPromptedRegion()
            self.regionVM.gameStatus = .during
        } else {
            regionVM.resetGameData()
            resetTimer()
            self.regionVM.gameStatus = .before
        }
    }
}

//struct ControlView_Previews: PreviewProvider {
//    static var previews: some View {
//        let statesvm = StatesViewModel()
//        statesvm.currentState = USState(name: "West Virginia", borders: [])
//        statesvm.gameStatus = .during
//        return ControlView(statesVM: statesvm)
//    }
//}




