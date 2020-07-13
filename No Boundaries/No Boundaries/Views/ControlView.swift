//
//  ControlView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/7/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

enum GameStatus {
    case before
    case during
    case lost
    case win
}

struct ControlView: View {
    
    @ObservedObject var statesVM: StatesViewModel
    @State var time = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack {
                    
                    if self.statesVM.gameStatus == .during {
                        
                        Text(self.statesVM.currentState?.name ?? "")
                            
                            .bold()
                            .font(.title)
                            .minimumScaleFactor(0.1)
                        
                        Spacer()
                        Text("\(self.time) sec.")
                            .minimumScaleFactor(0.1)
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()
                            .onReceive(self.timer) { _ in
                                if self.time < 999 {
                                    self.time += 1
                                }
                                
                        }
                        
                    } else if self.statesVM.gameStatus == .before {
                        HStack {
                            Text("No Bounds")
                                .bold()
                                .font(.title)
                            Spacer()
                            Text("highscore: \(UserDefaults.standard.integer(forKey: "score"))")
                                .foregroundColor(.gray)
                                .font(.headline)
                            Spacer()
                        }
                    } else if self.statesVM.gameStatus == .lost {
                        HStack {
                            Text("Game Over")
                                .bold()
                                .font(.title)
                            Spacer()
                            Text("\(self.statesVM.scoreState)/50 States")
                                .foregroundColor(.gray)
                                .font(.headline)
                            Spacer()
                        }
                    } else if self.statesVM.gameStatus == .win {
                        HStack {
                            Text("Bingo!")
                                .bold()
                                .font(.title)
                            Spacer()
                            Text("Your score was: \(self.statesVM.getSetScore(time: self.time))")
                                .foregroundColor(.gray)
                                .font(.headline)
                            Spacer()
                        }
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
                }.padding(.vertical, 20.0)
            }
        }
    }
    
    func resetTimer() {
        time = 0
    }
    
    func buttonTapped() {
        if statesVM.gameStatus == .before {
            statesVM.setCurrentState()
            self.statesVM.gameStatus = .during
        } else {
            statesVM.resetGameData()
            resetTimer()
            self.statesVM.gameStatus = .before
        }
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        let statesvm = StatesViewModel()
        statesvm.currentState = USState(name: "West Virginia", borders: [])
        statesvm.gameStatus = .during
        return ControlView(statesVM: statesvm)
    }
}


//For Rounding specific corners
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
