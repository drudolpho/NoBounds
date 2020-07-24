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
    
    @ObservedObject var regionVM: RegionViewModel
    @Binding var currentMode: Int
    
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
        if regionVM.gameStatus == .before {
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
            mapView.camera = GMSCameraPosition.camera(withLatitude: 40, longitude: -95.5, zoom: 3.0)
        }
        
        
        //New
        
        //Clears board on on reset
        guard let _ = self.regionVM.promptedRegion else {
            mapView.clear()
            return
        }
        
        if let borderData = regionVM.selectedRegion?.0.borders {
            let color = (regionVM.selectedRegion?.1 == true) ? UIColor(red: 0, green: 0.25, blue: 0, alpha: 0.5) : UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5)

            self.createRegionPolygons(borderData: borderData, color: color, mapView: mapView)
            
            self.regionVM.selectedRegionHasBeenDrawn()
        }
    }
    
    func createRegionPolygons(borderData: [[CoordData]], color: UIColor, mapView: GMSMapView) {
        for poly in borderData {
            let rect = GMSMutablePath()
            for coord in poly {
                guard let lat = CLLocationDegrees(exactly: coord.lat), let lon = CLLocationDegrees(exactly: coord.lon) else {
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
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
        
        @ObservedObject var statesVM: RegionViewModel
        var parent: GoogleMapsView
        
        init(_ parent: GoogleMapsView, viewModel: RegionViewModel) {
            self.parent = parent
            self.statesVM = viewModel
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            statesVM.handleTapAt(coordinate: coordinate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: regionVM)
    }
}





