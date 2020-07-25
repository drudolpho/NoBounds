//
//  RegionViewModel.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 7/2/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import SwiftUI
import GoogleMaps

class RegionViewModel: ObservableObject {
    
    var tabbedRegions: [String: Bool] = [:]
    @Published var promptedRegion: Region?
    @Published var selectedRegion: (Region, Bool)? //Bool indicates correctness of tap
    @Published var gameStatus: GameStatus = .before
    @Published var challenge: Challenge = .USA
    var remainingRegions: [String: Region] = [:]
    var stateList: [String: Region] = [:]
    var worldList: [String: Region] = [:]
    var scoredRegions: Int = 0
    var totalRegions: Int = 0
    
  
    init() {
        initializeRegions()
    }
    
    func setPromptedRegion() {
        let randomRegion = remainingRegions.values.randomElement()
        promptedRegion = randomRegion
        let regionName = randomRegion?.iso
        remainingRegions[regionName ?? ""] = nil
    }
    
    func selectedRegionHasBeenDrawn() {
        guard let name = selectedRegion?.0.name else { return }
        tabbedRegions[name] = true
    }
    
    func resetGameData() {
        self.gameStatus = .before
        scoredRegions = 0
        remainingRegions = [:]
  
        setRemainingRegions()
        tabbedRegions = [:]
        promptedRegion = nil
        selectedRegion = nil
    }
    
    func setRemainingRegions() {
        switch self.challenge {
        case .USA:
            self.remainingRegions = stateList
            self.totalRegions = stateList.count
        case .Europe:
            return
        case .Africa:
            return
        case .World:
            self.remainingRegions = worldList
            self.totalRegions = worldList.count
//            print("World list set (setRemainingRegions) \(remainingRegions.first?.value.name)")
        case .Asia:
            return
        case .SouthAmerica:
            return
        }
    }
    
    func getSetScore(time: Int, mode: Int) -> Int {
        let highscore = UserDefaults.standard.integer(forKey: "score")
        
        if mode == 0 && (highscore == 0 || time < highscore) {
            UserDefaults.standard.set(time, forKey: "score")
        }
        return time
    }
    
    func checkRegionCorrectness() -> Bool {
        if selectedRegion?.0.name == promptedRegion?.name {
            return true
        } else {
            if gameStatus == .during{
                gameStatus = .lost
            }
            return false
        }
    }
    
    func handleTapAt(coordinate: CLLocationCoordinate2D) {
//        print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
        
        
        //Google Geocoder
//        let geo = GMSGeocoder()
//        geo.reverseGeocodeCoordinate(coordinate) { (response, error) in
//            if let error = error {
//                print(error)
//            }
//            if let address: GMSAddress = (response?.firstResult()) {
//                print(address.country)
//            }
//        }
        
        // Apple Geocoder
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("error geocoding \(error)")
            } else {
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
                    print("\nAdministrativeArea: \(pm[0].administrativeArea ?? "")\nCountry: \(pm[0].country ?? "")\nISO: \(pm[0].isoCountryCode ?? "")\nName: \(pm[0].name ?? "")\n")
                    guard let regionIdentifier = self.challenge == .USA ? pm[0].administrativeArea : pm[0].isoCountryCode,
                        let tappedRegion = self.challenge == .USA ? self.stateList[regionIdentifier] : self.worldList[regionIdentifier] else { return }
                    print("ID:   \(regionIdentifier) !!!")
                    
                    
                    
                    if self.gameStatus == .during || self.gameStatus == .lost {
                        if self.tabbedRegions[tappedRegion.name] == nil {
                            self.selectedRegion = (tappedRegion, false)
                            let status = self.checkRegionCorrectness()
                            self.selectedRegion?.1 = status
                            self.tabbedRegions[tappedRegion.name] = false
                            if self.gameStatus == .during {
                                self.scoredRegions += 1
                                if self.scoredRegions == self.totalRegions { //should be self.totalRegions, lower for testing
                                    self.gameStatus = .win
                                } else {
                                    self.setPromptedRegion()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func initializeRegions() {
        
        //For US states
        if let url = Bundle.main.url(forResource: "states", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Region].self, from: data)
                
                for region in jsonData {
                    let temp = Region(name: region.name, iso: region.iso, borders: region.borders)
                    stateList[temp.iso] = temp
                    remainingRegions[temp.iso] = temp
                    totalRegions = stateList.count
                }
            } catch {
                print("error:\(error) with state list")
            }
        }
        
        //For world Countries
        if let url = Bundle.main.url(forResource: "countries", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode([Region].self, from: data)
                
                for region in jsonData {
                    let temp = Region(name: region.name, iso: region.iso, borders: region.borders)
                    worldList[temp.iso] = temp
                }
            } catch {
                print("error:\(error) with world list")
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
    
    
    let europeanCountries = ["Albania", "Andorra", "Armenia", "Austria", "Azerbaijan", "Belarus","Belgium", "Bosnia and Herzegovina", "Bulgaria","Croatia", "Cyprus", "Czech Republic", "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece", "Hungary", "Iceland", "Ireland", "Italy", "Kosovo", "Latvia", "Liechtenstein", "Lithuania", "Luxembourg", "Macedonia", "Malta", "Moldova", "Monaco", "Montenegro", "The Netherlands", "Norway", "Poland", "Portugal", "Romania", "Russia", "San Marino", "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Turkey", "Ukraine", "United Kingdom", "Vatican City",]
    
    let initialsDictionary: [String: String] = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
}
