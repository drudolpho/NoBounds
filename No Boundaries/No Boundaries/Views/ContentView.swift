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
    @State private var currentMode = 0
   
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GoogleMapsView(statesVM: self.statesVM, currentMode: self.$currentMode)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    BottomSheetView(
                        isOpen: self.$bottomSheetShown,
                        maxHeight: geometry.size.height * 0.7
                    ) {
                        VStack{
                            ControlView(statesVM: self.statesVM, bottomSheetShown: self.$bottomSheetShown, gameMode: self.$currentMode)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.18)
                            
                            PreferenceView(currentMode: self.$currentMode)

                            GuideView()

                            Spacer()
                        }
                    }
                }.edgesIgnoringSafeArea(.all)
            }
        }
    }
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

