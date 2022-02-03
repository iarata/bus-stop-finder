//
//  MapView.swift
//  Bus Finder
//
//  Created by Alireza Hajebrahimi on 2021/07/11.
//

import SwiftUI
import MapKit

// MARK: MapView
struct MapView: UIViewRepresentable {
    
    // MARK: Variables
    @Binding var stops: [Stops]
    @Binding var centerCoordinate: MKCoordinateRegion
    @Binding var action: Action
    
    @Binding var selectedStop: Stops
    @Binding var isDetailsActive: Bool
    
    // MARK: Action Lists
    enum Action {
        case idle
        case reset(coordinate: MKCoordinateRegion)
        case changeType(mapType: MKMapType)
    }
    
    // MARK: First Time Only
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.isUserInteractionEnabled = true
        mapView.centerCoordinate = self.centerCoordinate.center
        mapView.setRegion(self.centerCoordinate, animated: true)
        mapView.isRotateEnabled = false
        return mapView
    }
    
    // MARK: Updating UI
    func updateUIView(_ view: MKMapView, context: Context) {
        switch action {
        case .idle:
            break
        case .reset(let newCoordinate):
            view.delegate = nil
            
            DispatchQueue.main.async {
                self.centerCoordinate.center = newCoordinate.center
                self.action = .idle
                view.setRegion(self.centerCoordinate, animated: true)
                view.delegate = context.coordinator
            }
        case .changeType(let mapType):
            view.mapType = mapType
        }
        view.addAnnotations(stops)
    }
    
    // MARK: Setting Coordinator
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            parent.centerCoordinate.center = mapView.centerCoordinate
        }
        
        // MARK: Annotation View
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            
            // Checking if annotation type is 'MKUserLocation' then return nil
            if annotation is MKUserLocation { return nil }
            
            let identifier = "MyCustomAnnotation"
            
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            guard let annotation = annotation as? Stops else { return annotationView }
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                //                annotationView!.image = UIImage(systemName: "mappin")
                
            } else {
                annotationView!.annotation = annotation
            }
            configureDetailView(annotationView: annotationView!)
            return annotationView
        }
        
        // MARK: Annotation View Configuration
        func configureDetailView(annotationView: MKAnnotationView) {
            //            annotationView.detailCalloutAccessoryView = UIImageView(image: UIImage(systemName: "mappin"))
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if view.annotation is MKUserLocation {
                print("User Location Selected")
                return
            }
            
            let ibp = view.annotation as? Stops
            parent.selectedStop = ibp!
            parent.isDetailsActive = true
            
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if view.annotation is MKUserLocation {
                print("User Location Selected")
                return
            }
            parent.isDetailsActive = false
        }
    }
}
