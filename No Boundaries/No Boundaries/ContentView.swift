//
//  ContentView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("No Boundaries")
                    .font(.title)
                    .bold()
                    .padding()
                
                MapView()
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
        print("Start")
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
