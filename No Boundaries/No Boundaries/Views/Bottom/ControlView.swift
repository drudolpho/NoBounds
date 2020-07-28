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
    @Binding var animateControlButton: Bool
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
                        
                    } else if self.regionVM.gameStatus == .before {
                        Text("\(self.regionVM.challenge.rawValue)")
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.regionVM.challenge.rawValue)
                        Spacer()
                        HStack {
                            Button(action: {
                                self.lastChallenge()
                                self.regionVM.resetGameData()
                            }) {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height:16)
                                    .padding(.horizontal)
                                
                            }
//                            Divider()
                            Button(action: {
                                self.nextChallenge()
                                self.regionVM.resetGameData()
                            }) {
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height:16)
                                    .padding(.horizontal)
                            }
                        }
                        
                        
                    } else if self.regionVM.gameStatus == .lost {
                        Text("Game Over")
                            .bold()
                            .font(.title)
                        Spacer()
                        
                    } else if self.regionVM.gameStatus == .win {
                        Text(self.regionVM.promptedRegion?.name ?? "")
                            
                            .bold()
                            .font(.title)
                            .transition(.opacity)
                            .id(self.regionVM.promptedRegion?.name ?? "")
                        
                        Spacer()
                    }
                }.padding(.horizontal, 40.0)
                
                ZStack (alignment: .center) {
                    if self.regionVM.gameStatus != .before {
                        HStack {
                            HStack {
                                
                                Text("\(self.formatTime())")
                                .fixedSize(horizontal: true, vertical: false)
                                    .frame(width: geometry.size.width/9,alignment: .leading)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 8.0)
                                    .transition(.opacity)
                                    .id("\(self.time)")
                                    .onReceive(self.timer) { _ in
                                        if self.time < 9999 && self.regionVM.gameStatus == .during {
                                            self.time += 1
                                        }
                                }
                                
                                Divider()
                                
                                
                                Text("\(self.regionVM.scoredRegions)/\(self.regionVM.totalRegions)")
                                    .frame(width: geometry.size.width/9,alignment: .center)
                                    .foregroundColor(.gray)
                                    .font(.system(size: 12))
                                    .padding(.horizontal, 8.0)
                                    .transition(.opacity)
                                    .id("\(self.regionVM.scoredRegions)/\(self.regionVM.totalRegions)")
                                
                            }.frame(width:  geometry.size.width/2.4, height: geometry.size.height/3.4).background(Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)).cornerRadius(15)
                            Spacer()
                        }
                        .padding(.leading, 35.0)
                    }
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            self.buttonTapped()
                            withAnimation {
                                self.animateControlButton.toggle()
                            }
                        }) {
                            Text(self.regionVM.getButtonText())
                                .font(.title)
                                .fontWeight(.medium)
                                .frame(width: self.animateControlButton ? geometry.size.width/2.5 : geometry.size.width - 40, height: geometry.size.height/3.5)
                                .background(self.animateControlButton ? Color.blue : Color.green)
                                .foregroundColor(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 0)
                                .transition(.identity)
                                .id(self.regionVM.getButtonText())
                        }.padding([.leading, .trailing], 20.0).animation(.default)
                        //Animation.easeIn(duration: 3)
                    }
                }
            }
        }
    }
    
    func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func nextChallenge() {
        switch self.regionVM.challenge {
        case .USA:
            self.regionVM.challenge = .Europe
        case .Europe:
            self.regionVM.challenge = .Africa
        case .Africa:
            self.regionVM.challenge = .Asia
        case .World:
            self.regionVM.challenge = .USA
        case .Asia:
            self.regionVM.challenge = .SouthAmerica
        case .SouthAmerica:
            self.regionVM.challenge = .World
        }
    }
    
    func lastChallenge() {
        switch self.regionVM.challenge {
        case .USA:
            self.regionVM.challenge = .World
        case .Europe:
            self.regionVM.challenge = .USA
        case .Africa:
            self.regionVM.challenge = .Europe
        case .World:
            self.regionVM.challenge = .SouthAmerica
        case .Asia:
            self.regionVM.challenge = .Africa
        case .SouthAmerica:
            self.regionVM.challenge = .Asia
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




