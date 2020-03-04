//
//  Chico South.swift
//  SeeWorld
//
//  Created by Tomas Galvan-Huerta on 1/18/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseUI
// 6-8 feet
class ChicoStateLoc: NSObject{
    //let elevation = 59.13
    let ref: DatabaseReference = Database.database().reference()
    
    var ChicoStateLocations = [Spot]()
    func addall(){
        ChicoStateLocations = []
        addingTest()
       // StudentServicesBuilding()
        //trinityHall()
    }
    
    func addingTest(){
        let add = ref.childByAutoId()
        let test = [
            
            "Test": 124
        
        ] as [String : Any]
        add.setValue(test) { (error, reff) in
            if error != nil{
                print("There was an error: \(error!)")
            }
        }
        
        
    }
    
    func checkLocationSetup(view: UIViewController){
        locationManeger.requestAlwaysAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        if status != .authorizedAlways {
            let alert = UIAlertController(title: "Accept User Location", message: "To use this app, accept the Location Services", preferredStyle: .alert)
            let okalert = UIAlertAction(title: "Ok", style: .default) { (alert) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
            }
            alert.addAction(okalert)
            view.present(alert, animated: true, completion: nil)

        }
        
    }
    let locationManeger = CLLocationManager()
    
    func comparedistance(spot1: CLLocation, spot2: CLLocation) -> Double {
        let distanceInMeters = spot1.distance(from: spot2)// Distance in Meters
        return distanceInMeters
    }
    
    func addCloser(location inthese: [Spot]) -> Spot?{
        let closest = inthese.min { (first, second) -> Bool in
            let toMyFirst = comparedistance(spot1: first.cllocation, spot2: locationManeger.location!)
            let toMySecond = comparedistance(spot1: second.cllocation, spot2: locationManeger.location!)
            return toMyFirst < toMySecond
        }
        //print(closest?.name ?? "Nothing found")
        return closest
    }
    
    /*
    func StudentServicesBuilding(){
        var SSBdoors: [Spot] = []
        let south1 = Spot(plain_Lad: 39.726936, longitude: -121.845864, name: "Student Services Center South SSC")
        SSBdoors.append(south1)
        let west1 = Spot(plain_Lad: 39.727353, longitude: -121.846133, name: "Student Services Center West SSC")
        SSBdoors.append(west1)
        let east1 = Spot(plain_Lad: 39.727596, longitude: -121.845638, name: "Student Services Center East SSC"
        SSBdoors.append(east1)
        let east2 = Spot(plain_Lad: 39.727379, longitude: -121.845818, name: "Student Services Center East SSC", intrest: "Student Services", direction: .east)
        SSBdoors.append(east2)
        let north1 = Spot(plain_Lad: 39.727212, longitude: -121.845746, name: "Student Services Center North SSC", intrest: "Student Services", direction: .north)
        SSBdoors.append(north1)
        ChicoStateLocations.append(addCloser(location: SSBdoors) ?? north1)
        
    }
    func trinityHall(){
        var thDoors: [Spot] = []
        let north1 = Spot(plain_Lad: 39.7298, longitude: -121.8450, name: "Trinity Hall", intrest: "Trinity", direction: .north)
        thDoors.append(north1)
        let south1 = Spot(plain_Lad: 39.7296, longitude: -121.8446, name: "Trinity Hall", intrest: "Trinity", direction: .south)
        thDoors.append(south1)
        //print(addCloser(location: thDoors) ?? south1)
        ChicoStateLocations.append(addCloser(location: thDoors) ?? south1)
    }
    */
    
    
    
}
