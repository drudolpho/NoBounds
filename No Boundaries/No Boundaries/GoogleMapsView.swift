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
    
    @Binding var highlightedStates: [String]
    var allStatesDictData: [String: [CoordData]]
    
    
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
            guard let name = self.highlightedStates.last, let data = self.allStatesDictData[name] else { return }
            
            let rect = GMSMutablePath()
            for coord in data {
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
    }
    
    class Coordinator: NSObject, GMSMapViewDelegate {
      var parent: GoogleMapsView

        init(_ parent: GoogleMapsView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
            print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            geoCoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("error geocoding \(error)")
                } else {
                    let pm = placemarks! as [CLPlacemark]
                    if pm.count > 0 {
                        guard let stateInitials = pm[0].administrativeArea else { return }
                        
                        let statesDictionary: [String: String] = ["NM": "New Mexico", "SD": "South Dakota", "TN": "Tennessee", "VT": "Vermont", "WY": "Wyoming", "OR": "Oregon", "MI": "Michigan", "MS": "Mississippi", "WA": "Washington", "ID": "Idaho", "ND": "North Dakota", "GA": "Georgia", "UT": "Utah", "OH": "Ohio", "DE": "Delaware", "NC": "North Carolina", "NJ": "New Jersey", "IN": "Indiana", "IL": "Illinois", "HI": "Hawaii", "NH": "New Hampshire", "MO": "Missouri", "MD": "Maryland", "WV": "West Virginia", "MA": "Massachusetts", "IA": "Iowa", "KY": "Kentucky", "NE": "Nebraska", "SC": "South Carolina", "AZ": "Arizona", "KS": "Kansas", "NV": "Nevada", "WI": "Wisconsin", "RI": "Rhode Island", "FL": "Florida", "TX": "Texas", "AL": "Alabama", "CO": "Colorado", "AK": "Alaska", "VA": "Virginia", "AR": "Arkansas", "CA": "California", "LA": "Louisiana", "CT": "Connecticut", "NY": "New York", "MN": "Minnesota", "MT": "Montana", "OK": "Oklahoma", "PA": "Pennsylvania", "ME": "Maine"]
                        
                        self.parent.highlightedStates.append(statesDictionary[stateInitials] ?? "")
                    }
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }
}


struct StateData: Codable {
    var state: [SingleStateData]
}
struct SingleStateData: Codable {
    var point: [CoordData]
    var _name: String
    var _colour: String
}

struct CoordData: Codable {
    var _lat: String
    var _lng: String
}


