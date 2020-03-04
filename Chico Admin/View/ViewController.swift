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


class ViewController: UIViewController {
    
    let ref: DatabaseReference = Database.database().reference()
    let locationManeger = CLLocationManager()
    var laditude: Double?
    var longitude: Double?
    var key: String?
    var editingSpot: Spot?
    var group = ["Other"]
    var Allspot: [Spot] = []
    
    @IBOutlet weak var mapView: MKMapView!
 /*
    func addLocation(){
        let alert = UIAlertController(title: "New Location", message: "Fill out the name", preferredStyle: .alert)
        
        alert.addTextField { (text) in
            text.placeholder = "Name"
        }
        alert.addTextField { (text) in
            text.placeholder = "Laditude"
            text.keyboardType = .numbersAndPunctuation
        }
        alert.addTextField { (text) in
            text.placeholder = "Longitude"
            text.keyboardType = .numbersAndPunctuation
        }
        let bathroom = UIAlertAction(title: "Bathroom", style: .default) { (action) in
            guard let laditudetxt = alert.textFields?[1].text else {return}
            guard let longitudetxt = alert.textFields?[2].text else {return}
            guard let nametxt = alert.textFields?[0].text else {return}
            
            guard let laditude = Double(laditudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Laditude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            guard let longitude = Double(longitudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Longitude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            
            let type = "Bathroom"
            let center = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
            let circleOverlay = MKCircle(center: center, radius: 10)
            self.mapView.addOverlay(circleOverlay)
        }
        let building = UIAlertAction(title: "Building", style: .default) { (action) in
            guard let laditudetxt = alert.textFields?[2].text else {return}
            guard let longitudetxt = alert.textFields?[1].text else {return}
            guard let nametxt = alert.textFields?[0].text else {return}
            
            guard let laditude = Double(laditudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Laditude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            guard let longitude = Double(longitudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Longitude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            
            let type = "Building"
            
            let center = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
            let circleOverlay = MKCircle(center: center, radius: 10)
            self.mapView.addOverlay(circleOverlay)
        }
        let stairs = UIAlertAction(title: "Notice", style: .default) { (action) in
            guard let laditudetxt = alert.textFields?[2].text else {return}
            guard let longitudetxt = alert.textFields?[1].text else {return}
            guard let nametxt = alert.textFields?[0].text else {return}
            
            guard let laditude = Double(laditudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Laditude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            guard let longitude = Double(longitudetxt) else {let warning = UIAlertController(title: "Wanring", message: "Message not clear: Longitude", preferredStyle: .alert)
                let action = UIAlertAction(title: "Yes Sir!", style: .default, handler: nil)
                warning.addAction(action)
                self.present(warning, animated: true, completion: nil)
                return}
            
            let type = "Notice"
            
            let center = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
            let circleOverlay = MKCircle(center: center, radius: 10)
            self.mapView.addOverlay(circleOverlay)
        }
        alert.addAction(bathroom)
        alert.addAction(building)
        alert.addAction(stairs)
        
        present(alert, animated: true, completion: nil)
    }
*/
    
    @IBAction func Longpress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began{
            let touchpoint = sender.location(in: self.mapView)
            let location = mapView.convert(touchpoint, toCoordinateFrom: self.mapView)
            self.laditude = location.latitude
            self.longitude = location.longitude
            performSegue(withIdentifier: "InfoSegue", sender: self)
        }
        
        

//        let annotation = MKPointAnnotation()
//        annotation.title = "Latitude: \(location.latitude)"
//        annotation.subtitle = "Longitude: \(location.longitude)"
//        annotation.coordinate = location
//        mapView.addAnnotation(annotation)
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
        mapView.showsUserLocation = true
        mapView.showsBuildings = true
        let location = CLLocationCoordinate2D(latitude: 39.7278, longitude: -121.8459)
        let span = MKCoordinateSpan(latitudeDelta: 0.025, longitudeDelta: 0.025)
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
        }
        else{
            
        }
    }
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
    }
    
    
}
extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let key = view.annotation?.subtitle else {return}
        let myspot = Allspot.filter({ (pop) -> Bool in
            return pop.id == key
        })
        editingSpot = myspot.first
        performSegue(withIdentifier: "InfoSegue", sender: self)
        
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
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
            
        }
        
        return annotationView
    }
    
    
}

