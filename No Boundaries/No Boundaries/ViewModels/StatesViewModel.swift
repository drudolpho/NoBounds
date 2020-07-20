//
//  StatesViewModel.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/2/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleMaps

class StatesViewModel: ObservableObject {
    
    var tabbedStates: [String: Bool] = [:]
    @Published var promptedState: USState?
    @Published var selectedState: (USState, Bool)? //Bool indicates correctness of tap
    @Published var gameStatus: GameStatus = .before
    var remainingStates: [String: USState] = [:]
    var stateList: [String: USState] = [:]
    var scoredStates: Int = 0
    
    let initialsDictionary: [String: String] = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
    
    init() {
        initializeStates()
    }
    
    func setPromptedState() {
        let randomState = remainingStates.values.randomElement()
        promptedState = randomState
        let stateName = randomState?.name
        remainingStates[stateName ?? ""] = nil
    }
    
    func selectedStateHasBeenDrawn() {
        guard let name = selectedState?.0.name else { return }
        tabbedStates[name] = true
    }
    
    func resetGameData() {
        self.gameStatus = .before
        scoredStates = 0
        remainingStates = [:]
  
        remainingStates = stateList
        tabbedStates = [:]
        promptedState = nil
        selectedState = nil
    }
    
    func getSetScore(time: Int, mode: Int) -> Int {
        let highscore = UserDefaults.standard.integer(forKey: "score")
        
        if mode == 0 && (highscore == 0 || time < highscore) {
            UserDefaults.standard.set(time, forKey: "score")
        }
        return time
    }
    
    func checkStateCorrectness() -> Bool {
        if selectedState?.0.name == promptedState?.name {
            return true
        } else {
            if gameStatus == .during{
                gameStatus = .lost
            }
            return false
        }
    }
    
    func handleState(coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("error geocoding \(error)")
            } else {
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    guard let stateInitials = pm[0].administrativeArea,
                        let tappedState = self.stateList[self.initialsDictionary[stateInitials] ?? ""] else { return }
                    
                    
                    if self.gameStatus == .during || self.gameStatus == .lost {
                        if self.tabbedStates[tappedState.name] == nil {
                            self.selectedState = (tappedState, false)
                            let status = self.checkStateCorrectness()
                            self.selectedState?.1 = status
                            self.tabbedStates[tappedState.name] = false
                            if self.gameStatus == .during {
                                self.scoredStates += 1
                                if self.scoredStates == 3 { //should be self.stateList.count, lower for testing
                                    self.gameStatus = .win
                                } else {
                                    self.setPromptedState()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func initializeStates() {
        if let url = Bundle.main.url(forResource: "states", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(StateData.self, from: data)
                
                for state in jsonData.state {
                    let temp = USState(name: state._name, borders: state.point)
                    stateList[temp.name] = temp
//                    print(temp.name)
                    self.remainingStates[temp.name] = temp
                }
                return
            } catch {
                print("error:\(error)")
            }
        }
        return
    }
    
    func getButtonText() -> String {
        switch self.gameStatus {
        case .before:
            return "Start"
        default:
            return "Restart"
        }
    }
}
