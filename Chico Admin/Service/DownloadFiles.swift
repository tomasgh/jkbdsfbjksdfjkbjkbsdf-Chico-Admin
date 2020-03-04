//
//  DownloadFiles.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/20/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import Foundation
import FirebaseUI
import CoreLocation
import MapKit



extension ViewController{
    
    
    //    func singleGrabData(Laditude: Int, Longitude: Int){
    //           self.ref.child("Written Reviews").child(Laditude.description).child(Longitude.description).observeSingleEvent(of: .value) { (snapchat) in
    //               guard let snap = snapchat.value as? [String:Any] else {return}
    //               for snappy in snap{
    //                   if let dict = snappy.value as? [String:Any],
    //                       let longitude = dict["Longitude"] as? Double,
    //                       let uid = dict["uid"] as? String,
    //                       let ladditude = dict["Laditude"] as? Double,
    //                       let timeStamp = dict["TimeStamp"] as? Int,
    //                       let fireId = dict["fireId"] as? String,
    //                       let banned = dict["banned"] as? Bool,
    //                       let friend = dict["friends"] as?
    //let type = ["Building", "Stairs", "Bus Station","Warning", "Other"]
    
    func DownloadingThis(snap: [String: Any],of types: String){
        if let buildings = snap[types] as? [String:Any]{
            for type in buildings{
                if let group = type.value as? [String:Any]{ //Building
                    for sp in group.keys{
                        if let dict = group[sp] as? [String:Any], //ID
                            let name = dict["name"] as? String,
                            let longitude = dict["longitude"] as? Double,
                            let laditude = dict["laditude"] as? Double,
                            let info = dict["information"] as? String{
                            var spot = Spot(plain_Lad: laditude, longitude: longitude, name: name, type: types, groupABB: type.key, id: sp)
                            spot.info = info
                            Allspot.append(spot)
                            let mkann = MKPointAnnotation()
                            let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
                            self.addinggroup(singleGroup: type.key)
                            mkann.coordinate = coordinate
                            mkann.title = name
                            mkann.subtitle = sp
                            self.mapView.addAnnotation(mkann)
                            /*
                            if mapView.overlays.contains(where: { (overlay) -> Bool in
                                return overlay.subtitle == sp
                            }){//If it exists
                                let index1 = Allspot.firstIndex { (spot) -> Bool in
                                    spot.id == sp
                                }
                                let index2 = mapView.overlays.firstIndex { (overlay) -> Bool in
                                    overlay.subtitle == sp
                                }
                                var spot = Spot(plain_Lad: laditude, longitude: longitude, name: name, type: types, groupABB: type.key, id: sp)
                                spot.info = info
                                Allspot[index1!] = spot
                                let mkann = MKPointAnnotation()
                                let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
                                self.addinggroup(singleGroup: type.key)
                                mkann.coordinate = coordinate
                                mkann.title = name
                                mkann.subtitle = sp
                                let refernceann = mapView.annotations[index2!]
                                mapView.removeAnnotation(refernceann)
                                self.mapView.addAnnotation(mkann)
                            }
                            else{//If it does not exist
                                var spot = Spot(plain_Lad: laditude, longitude: longitude, name: name, type: types, groupABB: type.key, id: sp)
                                spot.info = info
                                Allspot.append(spot)
                                let mkann = MKPointAnnotation()
                                let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
                                self.addinggroup(singleGroup: type.key)
                                mkann.coordinate = coordinate
                                mkann.title = name
                                mkann.subtitle = sp
                                self.mapView.addAnnotation(mkann)
                            }*/
                            
                            
                        }
                    }
                }
            }
            
        }
    }
    //ref.observeSingleEvent(of: .value) { (snap) in
    
    func DownloadchangeinValue(snap: [String: Any],of types: String){
        let type = types
        if let identification = snap.first!.value as? [String:Any]{
            for sp in identification.keys{
                if let dict = identification[sp] as? [String: Any],
                    let name = dict["name"] as? String,
                    let longitude = dict["longitude"] as? Double,
                    let laditude = dict["laditude"] as? Double,
                    let info = dict["information"] as? String{
                    let index1 = Allspot.firstIndex { (spot) -> Bool in
                        spot.id == sp
                    }
                    let index2 = mapView.annotations.firstIndex { (overlay) -> Bool in
                        overlay.subtitle == sp
                    }
                    var spot = Spot(plain_Lad: laditude, longitude: longitude, name: name, type: types, groupABB: type, id: sp)
                    spot.info = info
                    Allspot[index1!] = spot
                    let mkann = MKPointAnnotation()
                    let coordinate = CLLocationCoordinate2D(latitude: laditude, longitude: longitude)
                    self.addinggroup(singleGroup: type)
                    mkann.coordinate = coordinate
                    mkann.title = name
                    mkann.subtitle = sp
                    if index2 == nil{
                        let refernceann = mapView.annotations[index2!]
                        mapView.removeAnnotation(refernceann)
                    }
                    self.mapView.addAnnotation(mkann)
                }
                
            }
            
        }
        
        
        
    }
    
    
    func downloadAndConvert(){
        let ref: DatabaseReference = Database.database().reference()
        ref.observe(.value) { (snap) in
            guard let sn = snap.value as? [String: Any] else {return}
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
            self.DownloadingThis(snap: sn, of: "Building")
            self.DownloadingThis(snap: sn, of: "Stairs")
            self.DownloadingThis(snap: sn, of: "Blue Lights")
            self.DownloadingThis(snap: sn, of: "Other")
            self.DownloadingThis(snap: sn, of: "Bus Station")
            self.DownloadingThis(snap: sn, of: "Warning")
        }
    }
    
    func continueDownloading(){
        let ref: DatabaseReference = Database.database().reference()
        ref.observe(.childAdded) { (snap) in
            guard let sn = snap.value as? [String: Any] else {return}
            print(sn)
            self.DownloadchangeinValue(snap: sn, of: "Building")
            self.DownloadchangeinValue(snap: sn, of: "Stairs")
            self.DownloadchangeinValue(snap: sn, of: "Blue Lights")
            self.DownloadchangeinValue(snap: sn, of: "Other")
            self.DownloadchangeinValue(snap: sn, of: "Bus Station")
            self.DownloadchangeinValue(snap: sn, of: "Warning")
        }
    }
    
    func addinggroup(singleGroup: String){
        if !(group.contains(singleGroup)){
            group.append(singleGroup)
        }
    }
    
    
    
}

