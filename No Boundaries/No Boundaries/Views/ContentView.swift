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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                GoogleMapsView(statesVM: self.statesVM)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Spacer()
                    //                    ControlView(statesVM: self.statesVM)
                    //
                    //                        .background(Color(red: 230/255, green: 240/255, blue: 240/255, opacity: 1))
                    //                        .cornerRadius(20, corners: [.topLeft, .topRight])
                    //                        .edgesIgnoringSafeArea(.bottom)
                    //                        .shadow(radius: 40)
                    //                        .frame(width: geometry.size.width, height: geometry.size.height / 6)
                    
                    BottomSheetView(
                        isOpen: self.$bottomSheetShown,
                        maxHeight: geometry.size.height * 0.7
                    ) {
                        ZStack{
                            ControlView(statesVM: self.statesVM)
                                .frame(width: geometry.size.width, height: geometry.size.height * 0.18)
//                                .background(Color.orange)
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

