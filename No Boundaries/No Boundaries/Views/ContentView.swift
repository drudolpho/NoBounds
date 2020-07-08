//
//  ContentView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct ContentView: View {
    
    @ObservedObject var statesVM = StatesViewModel()
//    @State var hasStarted = false
//    @State var time = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GoogleMapsView(statesVM: self.statesVM)
                    .edgesIgnoringSafeArea(.all)
//                    .cornerRadius(20)
//                    .padding(.bottom)
//                    .frame(width: geometry.size.width, height: geometry.size.height / 2.2)
                VStack {
                    Spacer()
                    ControlView(statesVM: self.statesVM)
                        
                        .background(Color(red: 230/255, green: 240/255, blue: 240/255, opacity: 1))
                        .cornerRadius(40)
                        .edgesIgnoringSafeArea(.bottom)
                        
                        .shadow(radius: 40)
                        .frame(width: geometry.size.width, height: geometry.size.height / 6)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 30)
//                                .stroke(Color.gray, lineWidth: 0.3)
//                        )
                }
                
                
//                VStack {
//                    Spacer()
//                    Text("No Boundaries")
//                        .font(.largeTitle)
//                        .bold()
//                        .padding()
//                    HStack {
//                        Text(self.statesVM.currentState?.name ?? "")
//                            .bold()
//                            .font(.title)
//                        Spacer()
//                        Text("\(self.statesVM.highlightedStates.count)/50")
//                        Spacer()
//                    }.padding(.horizontal, 70.0)
//                    Button(action: self.buttonTapped) {
//
//                        Text(self.statesVM.hasStarted ? "Restart" : "Start")
//                            .frame(width: geometry.size.width/2)
//                            .padding()
//                            .background(Color.green)
//                            .foregroundColor(Color.white)
//                            .cornerRadius(15)
//                    }
//
////                    Timer seems to update every view each time
//                    Text("\(self.time)")
//                        .padding()
//                        .onReceive(self.timer) { _ in
//                            if self.statesVM.hasStarted {
//                                self.time += 1
//                            } else {
//                                self.time = 0
//                            }
//                    }
//                }
            }
        }
    }
    
//    func resetTimer() {
//        time = 0
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var view = ContentView()
        
        let statesvm = StatesViewModel()
        statesvm.currentState = USState(name: "Kansas", borders: [])
        view.statesVM = statesvm
        return view
    }
}

