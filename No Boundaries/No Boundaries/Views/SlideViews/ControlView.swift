//
//  ControlView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/7/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct ControlView: View {
    
    @ObservedObject var statesVM: StatesViewModel
    @Binding var time: Int
    @Binding var bottomSheetShown: Bool
    @Binding var gameMode: Int
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(alignment: .lastTextBaseline) {
                    
                    if self.statesVM.gameStatus == .during {
                        
                        Text(self.statesVM.promptedState?.name ?? "")
                            
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.statesVM.promptedState?.name ?? "")
                        
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
                        
                    } else if self.statesVM.gameStatus == .before {
                        Text("United States")
                            .bold()
                            .font(.title)
                        Spacer()
                        Text("best: \(UserDefaults.standard.integer(forKey: "score")) sec")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                        
                    } else if self.statesVM.gameStatus == .lost {
                        Text("Game Over")
                            .bold()
                            .font(.title)
                        Spacer()
                        Text("\(self.statesVM.scoredStates)/50 States")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                        
                    } else if self.statesVM.gameStatus == .win {
                        Text("Bingo!")
                            .bold()
                            .font(.title)
                        Spacer()
                        Text("\(self.statesVM.getSetScore(time: self.time, mode: self.gameMode)) sec")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding(.trailing)
//                        Spacer()
                        
                    }
                }.padding(.horizontal, 35.0)
                
                Button(action: self.buttonTapped) {
                    Text(self.statesVM.getButtonText())
                        .font(.title)
                        .fontWeight(.medium)
                        .frame(width: geometry.size.width/1.2, height: geometry.size.height/3.5)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                        .shadow(radius: 0)
                        .transition(.opacity)
                        .id(self.statesVM.getButtonText())
                }.padding(.vertical, 20.0)
            }
        }
    }
    
    func resetTimer() {
        time = 0
    }
    
    func buttonTapped() {
        if statesVM.gameStatus == .before {
            self.bottomSheetShown = false
            statesVM.setPromptedState()
            self.statesVM.gameStatus = .during
        } else {
            statesVM.resetGameData()
            resetTimer()
            self.statesVM.gameStatus = .before
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




