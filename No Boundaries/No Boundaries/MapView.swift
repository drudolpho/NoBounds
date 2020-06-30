//
//  MapView.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/24/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        let coordinate = CLLocationCoordinate2D(latitude: 40, longitude: -95.5)
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 60)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.region = region
        mapView.delegate = context.coordinator
        
        var overlayBoundingMapRect: MKMapRect {
          let topLeft = MKMapPoint(CLLocationCoordinate2D(latitude: 52, longitude: -128.5))
          let topRight = MKMapPoint(CLLocationCoordinate2D(latitude: 52, longitude: -64.5))
          let bottomLeft = MKMapPoint(CLLocationCoordinate2D(latitude: 10, longitude: -128.5))

          return MKMapRect(
            x: topLeft.x,
            y: topLeft.y,
            width: fabs(topLeft.x - topRight.x),
            height: fabs(topLeft.y - bottomLeft.y))
        }
        
        let overlay = ImageOverlay(coordinate: coordinate, boundingMapRect: overlayBoundingMapRect)
        mapView.addOverlay(overlay)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
      var parent: MapView

      init(_ parent: MapView) {
        self.parent = parent
      }

      func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ImageOverlay {
          return ImageOverlayRenderer(
            overlay: overlay,
            overlayImage: UIImage(imageLiteralResourceName: "testUSA"))
        }

        return MKOverlayRenderer()
      }
    }
    
    func makeCoordinator() -> Coordinator {
      Coordinator(self)
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}

