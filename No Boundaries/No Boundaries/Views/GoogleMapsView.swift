//
//  GoogleMapsView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/29/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import GoogleMaps

struct GoogleMapsView: UIViewRepresentable {
    
    @ObservedObject var statesVM: StatesViewModel
    @Binding var currentMode: Int
//    var num = 0 //dont know what this does
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 40, longitude: -95.5, zoom: 3.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        do {
          if let styleURL = Bundle.main.url(forResource: "teststyle", withExtension: "json") {
            mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
          } else {
            NSLog("Unable to find style.json")
          }
        } catch {
          NSLog("One or more of the map styles failed to load. \(error)")
        }
        return mapView
    }
    
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        if statesVM.gameStatus == .before {
            var styleFileName = "teststyle"
            
            switch currentMode {
            case 1:
                styleFileName = "practicestyle"
            case 2:
                styleFileName = "studystyle"
            default:
                styleFileName = "teststyle"
            }
            
            do {
                if let styleURL = Bundle.main.url(forResource: styleFileName, withExtension: "json") {
                    mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                } else {
                    NSLog("Unable to find style.json")
                }
            } catch {
                NSLog("One or more of the map styles failed to load. \(error)")
            }
        }
        
        
        //New
        
        //Clears board on on reset
        guard let _ = self.statesVM.promptedState else {
            mapView.clear()
            return
        }
        
        if let borderData = statesVM.selectedState?.0.borders {
            let color = (statesVM.selectedState?.1 == true) ? UIColor(red: 0, green: 0.25, blue: 0, alpha: 0.5) : UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5)

            self.createStateBorderPolygon(borderData: borderData, color: color, mapView: mapView)
            
            self.statesVM.selectedStateHasBeenDrawn()
            //checkGameStatus()
        }
        
        
        
        
        
        
        
//        guard let promptedState = self.statesVM.promptedState else {
//            mapView.clear()
//            return
//        }
//        DispatchQueue.main.async {
//
//            if self.statesVM.tabbedStates == [:] {
//                //erase all polygons
//                mapView.clear()
//            } else if self.statesVM.tabbedStates.count > 0
//                && self.statesVM.tabbedStates.count < 51 {
//                var color = UIColor(red: 0, green: 0.25, blue: 0, alpha: 0.5)
//                if self.statesVM.gameStatus == .lost {
//                    color = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5);
//                }
        
//                if self.statesVM.tabbedStates[promptedState.name] == false {
//                    self.createStateBorderPolygon(borderData: promptedState.borders, color: color, mapView: mapView)
//                    self.statesVM.stateHasBeenDrawn(state: promptedState)
//                    if self.statesVM.tabbedStates.count == 3 && self.statesVM.gameStatus != .lost { //3 for testing
//                        //Win
//                        self.statesVM.gameStatus = .win
//                    } else {
//                        self.statesVM.setPromptedState()
//                    }
//                }
//            }
//        }
    }
    
    func createStateBorderPolygon(borderData: [CoordData], color: UIColor, mapView: GMSMapView) {
        let rect = GMSMutablePath()
        for coord in borderData {
            guard let lat = CLLocationDegrees(exactly: Double(coord._lat) ?? 0), let lon = CLLocationDegrees(exactly: Double(coord._lng) ?? 0) else {
                print("Problem with coordinates")
                return
            }
            rect.add(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = color
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        
        @ObservedObject var statesVM: StatesViewModel
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView, viewModel: StatesViewModel) {
            self.parent = parent
            self.statesVM = viewModel
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            statesVM.handleState(coordinate: coordinate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: statesVM)
    }
}





