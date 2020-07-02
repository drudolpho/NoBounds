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
    
    func makeUIView(context: Self.Context) -> GMSMapView {
        let camera = GMSCameraPosition.camera(withLatitude: 40, longitude: -95.5, zoom: 3.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.delegate = context.coordinator
        do {
          if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
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
        DispatchQueue.main.async {
            
            if self.statesVM.highlightedStates.count == 0 {
                //erase all polygons
            } else if self.statesVM.highlightedStates.count < 50 {
                //draw state
                guard let state = self.statesVM.highlightedStates.last else { return }
                self.createStateBorderPolygon(borderData: state.borders, mapView: mapView)
            } else {
                //win
            }
        }
    }
    
    func createStateBorderPolygon(borderData: [CoordData], mapView: GMSMapView) {
        let rect = GMSMutablePath()
        for coord in borderData {
            guard let lat = CLLocationDegrees(exactly: Double(coord._lat) ?? 0), let lon = CLLocationDegrees(exactly: Double(coord._lng) ?? 0) else {
                print("Problem with coordinates")
                return
            }
            rect.add(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5);
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
            statesVM.addState(coordinate: coordinate)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, viewModel: statesVM)
    }
}





