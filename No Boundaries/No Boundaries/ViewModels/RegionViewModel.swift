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
    
    func correctedRegionHasBeenDrawn() {
        guard let name = promptedRegion?.name else { return }
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
            for iso in self.euISO {
                remainingRegions[iso] = worldList[iso]
            }
            self.totalRegions = remainingRegions.count
        case .Africa:
            for iso in self.afISO {
                remainingRegions[iso] = worldList[iso]
            }
            self.totalRegions = remainingRegions.count
        case .World:
            for iso in self.wdISO {
                remainingRegions[iso] = worldList[iso]
            }
            self.totalRegions = remainingRegions.count
        case .Asia:
            for iso in self.asISO {
                remainingRegions[iso] = worldList[iso]
            }
            self.totalRegions = remainingRegions.count
        case .SouthAmerica:
            for iso in self.saISO {
                remainingRegions[iso] = worldList[iso]
            }
            self.totalRegions = remainingRegions.count
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
//        print("{\n\"lat\": \(coordinate.latitude),\n\"lon\": \(coordinate.longitude)\n},")

        // Apple Geocoder
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("error geocoding \(error)")
            } else {
                let pm = placemarks! as [CLPlacemark]
                if pm.count > 0 {
//                    print("\nAdministrativeArea: \(pm[0].administrativeArea ?? "")\nCountry: \(pm[0].country ?? "")\nISO: \(pm[0].isoCountryCode ?? "")\nName: \(pm[0].name ?? "")\n")
                    guard let regionIdentifier = self.challenge == .USA ? pm[0].administrativeArea : pm[0].isoCountryCode,
                        let tappedRegion = self.challenge == .USA ? self.stateList[regionIdentifier] : self.worldList[regionIdentifier] else { return }

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
                    let temp = Region(name: region.name, iso: region.iso, center: region.center, borders: region.borders)
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
                    let temp = Region(name: region.name, iso: region.iso, center: region.center, borders: region.borders)
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
    
    //Countries for each challenge by ISO
    let saISO = ["AR","CL","UY","BR","BO","PE","CO","VE","GY","SR","EC","PY", "GF"]
    
    let asISO = ["RU","KZ","UZ","ID","TL","IL","LB","JO","AE","QA","KW","IQ","OM","KH","TH", "LA","MM","VN","KP", "KR","MN","IN","BD","BT", "NP","PK","AF","TJ","KG","TM","IR", "SY","AM","TR","LK","CN", "TW","AZ","GE","PH", "MY","BN","JP","YE", "SA","CY", "PG"]
    
    let afISO = ["TZ","CD","SO","KE","SD","TD","ZA","LS","ZW","BW","NA","SN","ML","MR","BJ","NE","NG","CM","TG","GH", "CI","GN","GW","LR", "SL","BF","CF","CG","GA","GQ","ZM", "MW","MZ", "SZ", "AO","BI","MG","GM","TN","DZ","ER","MA", "EG","LY","ET","DJ","UG","RW","SS"]
    
    let euISO = ["FR","NO","SE","BY","UA","PL","AT","HU","MD","RO","LT","LV","EE","DE","BG","GR","AL","HR","CH", "LU","BE","NL","PT","ES","IE","IT","DK","GB","IS","SI","FI","SK", "CZ","BA","MK","RS","ME"]
    
    let wdISO = ["US","CA","MX", "AR","CL","UY","BR","BO","PE","CO","VE","GY", "SR","EC","PY", "GF","TZ","CD","SO","KE","SD","TD","ZA", "LS","ZW","BW","NA","SN","ML","MR","BJ","NE","NG","CM","TG","GH", "CI","GN","GW","LR", "SL","BF","CF","CG","GA","GQ","ZM", "MW","MZ", "SZ", "AO","BI","MG","GM","TN","DZ","ER","MA", "EG","LY","ET","DJ","UG","RW","SS", "RU","KZ","UZ","ID","TL","IL","LB", "JO","AE","QA", "KW","IQ","OM","KH","TH", "LA","MM","VN","KP", "KR","MN","IN","BD","BT", "NP","PK","AF","TJ","KG","TM","IR", "SY","AM","TR","LK","CN", "TW","AZ","GE","PH", "MY","BN","JP","YE", "SA","CY", "PG", "FR","NO","SE","BY","UA","PL","AT","HU", "MD","RO","LT","LV","EE", "DE","BG","GR","AL","HR","CH", "LU","BE","NL","PT","ES","IE", "IT","DK","GB","IS","SI","FI","SK", "CZ","BA","MK","RS","ME", "AU", "NZ", "AQ", "CU", "DO", "HT", "JM", "BS", "BZ", "GT", "HN", "SV", "NI", "CR", "PA", "GL"]

}
