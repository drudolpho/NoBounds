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
            mapView.clear()
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
            
            //draw out of bounds areas
            createRegionPolygons(borderData: self.regionVM.worldList["XK"]?.borders ?? [], color: UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5), mapView: mapView, border: false)
            createRegionPolygons(borderData: self.regionVM.worldList["EH"]?.borders ?? [], color: UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5), mapView: mapView, border: false)
            createRegionPolygons(borderData: self.regionVM.worldList["01"]?.borders ?? [], color: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.5), mapView: mapView, border: false)
            createRegionPolygons(borderData: self.regionVM.worldList["02"]?.borders ?? [], color: UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.5), mapView: mapView, border: false)
            
            //moves camera to challenge zone
            switch self.regionVM.challenge {
            case .USA:
                moveTo(map: mapView, lat: 38, lon: -95.5, zoom: 3)
            case .Europe:
                moveTo(map: mapView, lat: 53, lon: 13, zoom: 3.2)
            case .Africa:
                moveTo(map: mapView, lat: 2, lon: 16, zoom: 2.7)
            case .World:
                moveTo(map: mapView, lat: 7, lon: -90.5, zoom: 0)
            case .Asia:
                moveTo(map: mapView, lat: 45, lon: 90, zoom: 2.2)
            case .SouthAmerica:
                moveTo(map: mapView, lat: -28, lon: -61, zoom: 3)
            }
        }

        
        if let borderData = regionVM.selectedRegion?.0.borders {
            let color = (regionVM.selectedRegion?.1 == true) ? UIColor(red: 0, green: 0.25, blue: 0, alpha: 0.5) : UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5)

            self.createRegionPolygons(borderData: borderData, color: color, mapView: mapView, border: true)
            
            self.regionVM.selectedRegionHasBeenDrawn()
        }
        
        if regionVM.gameStatus == .lost {
            
            guard let promptedRegion = self.regionVM.promptedRegion else { return }
            guard self.regionVM.tabbedRegions[promptedRegion.name] == nil else { return }
            
            moveTo(map: mapView, lat: promptedRegion.center.lat, lon: promptedRegion.center.lon, zoom: 4)
            createRegionPolygons(borderData: promptedRegion.borders, color: UIColor(red: 0, green: 0, blue: 0.25, alpha: 0.5), mapView: mapView, border: true)
            self.regionVM.correctedRegionHasBeenDrawn()
        }
    }
    
    func moveTo(map: GMSMapView, lat: Double, lon: Double, zoom: Float) {
        map.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        map.animate(toZoom: zoom)
    }
    
    func createRegionPolygons(borderData: [[CoordData]], color: UIColor, mapView: GMSMapView, border: Bool) {
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
            if border {
                polygon.strokeColor = .black
                polygon.strokeWidth = 2
            }
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





