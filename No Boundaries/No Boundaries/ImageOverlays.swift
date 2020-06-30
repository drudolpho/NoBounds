//
//  ImageOverlays.swift
//  No Boundaries
//
//  Created by Dennis Rudolph on 6/29/20.
//  Copyright © 2020 Dennis Rudolph. All rights reserved.
//

import Foundation
import MapKit

class ImageOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    
    var boundingMapRect: MKMapRect
    
    init(coordinate: CLLocationCoordinate2D, boundingMapRect: MKMapRect) {
        self.coordinate = coordinate
        self.boundingMapRect = boundingMapRect
    }
}


class ImageOverlayRenderer: MKOverlayRenderer {
  let overlayImage: UIImage

  init(overlay: MKOverlay, overlayImage: UIImage) {
    self.overlayImage = overlayImage
    super.init(overlay: overlay)
  }

  override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
    guard let imageReference = overlayImage.cgImage else { return }

    let rect = self.rect(for: overlay.boundingMapRect)
    context.scaleBy(x: 1.0, y: -1.0)
    context.translateBy(x: 0.0, y: -rect.size.height)
    context.draw(imageReference, in: rect)
  }
}
