//
//  ViewController.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/4/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseAuth
import FirebaseUI
import SwiftUI


class ViewController: UIViewController {
    
    let ref: DatabaseReference = Database.database().reference()
    let locationManeger = CLLocationManager()
    var laditude: Double?
    var longitude: Double?
    var key: String?
    var editingSpot: Spot?
    var group = ["Other"]
    var Allspot: [Spot] = []
    var isLocationOn = false
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBAction func Longpress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let touchpoint = sender.location(in: self.mapView)
            let location = mapView.convert(touchpoint, toCoordinateFrom: self.mapView)
            let thislocation = CLLocation(latitude: location.latitude, longitude: location.longitude).coordinate
            self.isLocationOn = true
            let data = DataLocation()
            data.Laditude = thislocation.latitude
            data.Longitude = thislocation.longitude
            data.groups = group
            print(self.isLocationOn)
            let vc = UIHostingController(rootView: AddingLocation(newSpot: data, mylocation: thislocation, loctionsisOn: isLocationOn, dismissAction: {
                self.dismiss(animated: true, completion: nil)
            }))
            present(vc, animated: true)
            
            //performSegue(withIdentifier: "InfoSegue", sender: self)
        }

    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoSegue" {
            let vc = segue.destination as! AddingViewController
            if editingSpot != nil{
                vc.editingSpot = editingSpot
                vc.laditude = editingSpot?.laditude
                vc.longitude = editingSpot?.longitude
                vc.group = group
            }
            else{
                guard let long = longitude,
                    let lad = laditude else {return}
                vc.laditude = lad
                print(group)
                vc.longitude = long
                vc.group = group
                
            }
            
            editingSpot = nil
            
        }
        
    }
    func setMapLocation(){
        //MapView.delegate = self
        mapView.layer.masksToBounds = true;
        mapView.showsScale = true
        mapView.showsBuildings = true
        let location = CLLocationCoordinate2D(latitude: 39.7278, longitude: -121.8459)
        let span = MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        mapView.centerCoordinate = location
        
        
    }
    
    func authenticate(){
        Auth.auth().signInAnonymously() { (authResult, error) in
            guard error != nil else{print(error as Any)
                return}
            print("Sucessfully Signed in Anonymously")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticate()
        mapView.delegate = self
        locationManeger.requestWhenInUseAuthorization()
        setMapLocation()
        downloadAndConvert()
        //continueDownloading()
        
        //addLocation()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func myUnwindAction(segue: UIStoryboardSegue) {}

    
}
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            locationManeger.startUpdatingLocation()
            self.downloadAndConvert()
        }
        else{
            
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
}
extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this?", preferredStyle: .alert)
        let delete = UIAlertAction(title: "Yes Homie", style: .destructive) { (alert) in
            let index = self.Allspot.first { (spot) -> Bool in
                let lad = spot.cllocation.coordinate == view.annotation?.coordinate
                print(lad)
                if lad{
                    return true
                }
                else{
                    return false
                }
            }            
            if index != nil{
                self.ref.child((index?.type)!).child((index?.group)!).child((index?.id)!).removeValue()
            }
            
        }
        let nodeelete = UIAlertAction(title: "No, My Mistake", style: .default, handler: nil)
        alert.addAction(delete)
        alert.addAction(nodeelete)
        self.present(alert, animated: true, completion: {
            view.isSelected = false
        })
        
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        print(overlay)
        if overlay is MKCircle {
            let render = MKCircleRenderer(overlay: overlay)
            render.fillColor = .orange
            render.alpha = 0.5
            return render
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {return nil}
        let annotationse = MKAnnotationView(annotation: annotation, reuseIdentifier: annotation.subtitle!!)
        annotationse.image = UIImage(named: annotation.subtitle!!)?.resized(to: CGSize(width: 15.0, height: 15.0))
        return annotationse
    }
}

extension CLLocationCoordinate2D: Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        if lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude{
            return true
        }
        else{
            return false
        }
    }
    
    
}
