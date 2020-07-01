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
    
    @State var highlightedStates: [String] = []
    var allStatesDictData: [String: [CoordData]] {
        fetchData()
    }
   
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Text("No Boundaries")
                    .font(.title)
                    .bold()
                    .padding()
                
                //Google Maps SDK
                GoogleMapsView(highlightedStates: self.$highlightedStates, allStatesDictData: self.allStatesDictData)
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
//        let testState = USstate(name: "test", coordinates: [])
//        highlightedStates.append(testState)
    }
    
    func fetchData() -> [String: [CoordData]]{
        if let url = Bundle.main.url(forResource: "states", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(StateData.self, from: data)
                
                var allStatesDictData: [String: [CoordData]] = [:]
                for state in jsonData.state {
                    allStatesDictData[state._name] = state.point
                }
                
                return allStatesDictData
                
            } catch {
                print("error:\(error)")
            }
        }
        return [:]
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
