//
//  Spots.swift
//  SeeWorld
//
//  Created by Tomas Galvan-Huerta on 1/18/20.
//  Copyright © 2020 Somat. All rights reserved.
//  Created by Tomas Galvan-Huerta on 12/31/18. In FaceNorth Under Locations.swift
//

import Foundation
//import ARKit
import CoreLocation

//Example
/*
 do {
     let jsonData = try JSONEncoder().encode(sentences)
     let jsonString = String(data: jsonData, encoding: .utf8)!
     print(jsonString) // [{"sentence":"Hello world","lang":"en"},{"sentence":"Hallo Welt","lang":"de"}]

     // and decode it back
     let decodedSentences = try JSONDecoder().decode([Sentence].self, from: jsonData)
     print(decodedSentences)
 } catch { print(error) }
 */

enum direction{
    case north
    case south
    case east
    case west
    case none
}

enum type: String{
    case bathroom = "bathroom"
    case building = "building"
    case stairs = "stairs"
    case waterFountains = "waterFountain"
}
struct JSpot: Codable{
    let laditude: Double?
    let longitude:Double?
    let altitude: Double?
    let image: String?
    let type: String
    let name: String
}

struct Spot{
    let laditude: Double?
    let longitude:Double?
    let altitude: Double?
    let image: String?
    //let node: SCNNode?
    var type: String?
    var group: String?
    let name: String
    var info: String? = nil
   // let elevation: Double?
    let cllocation: CLLocation
    var id: String?
    //var portalImage: UIImage?
    
    
//    init(Image_Lad laditude: Double, longitude: Double, altitude: Double, image: String?, name: String, elevation: Double?) {
//        self.laditude = laditude
//        self.longitude = longitude
//        self.altitude = altitude
//        self.image  = image
//        self.name = name
//        self.elevation = elevation
//        self.node = nil
//        self.cllocation = CLLocation(latitude: self.laditude!, longitude: self.longitude!)
//        self.portalImage = nil
//    }
//    init(Node_Lad laditude: Double, longitude: Double, altitude: Double, mynode: SCNNode?, name: String, elevation: Double?) {
//        self.laditude = laditude
//        self.longitude = longitude
//        self.altitude = altitude
//        self.node  = mynode
//        self.name = name
//        self.image = nil
//        self.elevation = elevation
//        self.cllocation = CLLocation(latitude: self.laditude!, longitude: self.longitude!)
//        self.portalImage = nil
//    }
    init(plain_Lad laditude: Double, longitude: Double, name: String, type: String, groupABB: String, id: String) {
        self.laditude = laditude
        self.longitude = longitude
        self.altitude = nil
//        self.node  = nil
        
        self.name = name
        self.image = nil
        //self.elevation = nil
        self.cllocation = CLLocation(latitude: self.laditude!, longitude: self.longitude!)
        self.type = type
        self.group = groupABB
        self.id = id
//        self.portalImage = nil
        
    }
    init(plain_cll clocation: CLLocation, name: String, type: String, groupABB: String, id: String) {
        self.altitude = nil
//        self.node  = nil
        self.name = name
        self.image = nil
        //self.elevation = nil
        self.cllocation = clocation
//        self.portalImage = nil
        self.laditude = cllocation.coordinate.latitude
        self.longitude = cllocation.coordinate.longitude
        self.type = type
        self.group = groupABB
        self.id = id
        
    }
//    init(Node_cll clocation: CLLocation, altitude: Double, mynode: SCNNode?, name: String, elevation: Double?) {
//        self.altitude = altitude
//        self.node  = mynode
//        self.name = name
//        self.image = nil
//        self.elevation = elevation
//        self.cllocation = clocation
//        self.portalImage = nil
//        self.laditude = cllocation.coordinate.latitude
//        self.longitude = cllocation.coordinate.longitude
//    }
//    init(Image_cll clocation: CLLocation, altitude: Double, image: String?, name: String, elevation: Double?) {
//        self.altitude = altitude
//        self.image  = image
//        self.name = name
//        self.elevation = elevation
////        self.node = nil
//        self.cllocation = clocation
////        self.portalImage = nil
//        self.laditude = cllocation.coordinate.latitude
//        self.longitude = cllocation.coordinate.longitude
//    }
    
    
}


