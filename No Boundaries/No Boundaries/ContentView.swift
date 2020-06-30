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
    var statesDictionary: [String: String] = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
    
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
