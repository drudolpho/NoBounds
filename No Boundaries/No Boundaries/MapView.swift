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
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let coordinate = CLLocationCoordinate2D(latitude: 40, longitude: -95.5)
        let span = MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 60)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        uiView.setRegion(region, animated: false)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}








//class ImageOverlay : NSObject, MKOverlay {
//
//    let image: UIImage
//    let boundingMapRect: MKMapRect
//    let coordinate: CLLocationCoordinate2D
//
//    init(image: UIImage, rect: MKMapRect) {
//        self.image = image
//        self.boundingMapRect = rect
//        self.coordinate = CLLocationCoordinate2D(latitude: 40, longitude: -95.5)
//    }
//}
//
//class ImageOverlayRenderer : MKOverlayRenderer {
//
//    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
//
//        guard let overlay = self.overlay as? ImageOverlay else {
//            return
//        }
//
//        let rect = self.rect(for: overlay.boundingMapRect)
//
//        UIGraphicsPushContext(context)
//        overlay.image.draw(in: rect)
//        UIGraphicsPopContext()
//    }
//}
