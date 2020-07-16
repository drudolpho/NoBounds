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
    @State private var bottomSheetShown = false
//    @State private var showingSubmitView = true
    @State var time = 0
    @State private var currentMode = 0
   
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GoogleMapsView(statesVM: self.statesVM, currentMode: self.$currentMode)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
                
                VStack {
                    Spacer()
                    
                    BottomSheetView(
                        isOpen: self.$bottomSheetShown,
                        maxHeight: geometry.size.height * 0.7
                    ) {
                        VStack{
                            ControlView(statesVM: self.statesVM, time: self.$time, bottomSheetShown: self.$bottomSheetShown, gameMode: self.$currentMode)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.18)
                            
                            PreferenceView(currentMode: self.$currentMode)
                            
                            GuideView()
                            
                            Spacer()
                        }
                    }
                }.edgesIgnoringSafeArea(.all).zIndex(1)
                
                if self.statesVM.gameStatus == .win {
                    SubmitView(statesVM: self.statesVM, time: self.$time, submitting: false)
                        .frame(width: 300, height: 200, alignment: .center)
                        .background(Color.white)
                        .cornerRadius(20)
                        .transition(AnyTransition.scale.animation(.spring()))
                        .zIndex(2)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        var view = ContentView()
        
        let statesvm = StatesViewModel()
        statesvm.promptedState = USState(name: "Kansas", borders: [])
        view.statesVM = statesvm
        return view
    }
}

