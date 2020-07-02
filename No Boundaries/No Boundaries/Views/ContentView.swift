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

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("No Boundaries")
                    .font(.title)
                    .bold()
                    .padding()
                
                GoogleMapsView(statesVM: self.statesVM)
                    .cornerRadius(20)
                    .padding(.bottom)
                    .frame(width: geometry.size.width, height: geometry.size.height / 2.2)
                
                Button(action: self.buttonTapped) {
                    Text("Start")
                        .padding()
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(15)
                }
            }
        }
    }
    
    func buttonTapped() {
        //Start
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
