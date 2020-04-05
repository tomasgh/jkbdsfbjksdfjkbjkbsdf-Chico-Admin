//
//  mapView.swift
//  SwiftUIExample
//
//  Created by Tomas Galvan-Huerta on 3/28/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapViewConroller: UIViewRepresentable{
    @Binding var Status: Bool
    @State var mylocation: CLLocationCoordinate2D
    @Binding var typeForPicture: Int
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .hybrid
        mapView.isUserInteractionEnabled = false
        mapView.delegate = context.coordinator
        if Status{
            mapView.setCenter(mylocation, animated: true)
            let mkspan = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
            let region = MKCoordinateRegion(center: mylocation, span: mkspan)
            let mkann = MKPointAnnotation()
            mkann.coordinate = region.center
            mapView.addAnnotation(mkann)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                mapView.setCenter(self.mylocation, animated: true)
                mapView.setRegion(region, animated: true)
                
            }        }
        let tap = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.triggerTouchAction(gestureReconizer:)))
        mapView.addGestureRecognizer(tap)
        return mapView
    }
    

    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewConroller>) {
        uiView.removeAnnotations(uiView.annotations)
        let mkann = MKPointAnnotation()
        mkann.coordinate = mylocation
        uiView.addAnnotation(mkann)
        

        
    }
    func makeCoordinator() -> MapViewConroller.Coordinator {
        Coordinator(self)
    }


    class Coordinator: NSObject, MKMapViewDelegate{
        var parent: MapViewConroller
        
        @objc func triggerTouchAction(gestureReconizer: UITapGestureRecognizer) {
              //Add alert to show it works
            print("Tap")
        }
        
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
            let annotationse = MKAnnotationView(annotation: annotation, reuseIdentifier: types[parent.typeForPicture])
            annotationse.image = UIImage(named: annotationse.reuseIdentifier!)?.resized(to: CGSize(width: 25.0, height: 25.0))
            return annotationse
        }
        
        init(_ parent: MapViewConroller) {
            self.parent = parent
        }
        
         
    }
}



struct MapView: View{
    @State var Status: Bool = false
    @State var mylocation = CLLocationCoordinate2D(latitude: -121.8460895171, longitude: 39.72762659149)
    @State var type = 1
    var body: some View{
        
        MapViewConroller(Status: $Status, mylocation: mylocation, typeForPicture: $type).edgesIgnoringSafeArea(.all)
    }

}

struct mapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView()
    }
}
extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
