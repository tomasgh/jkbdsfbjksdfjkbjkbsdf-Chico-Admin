//
//  DeleteFiles.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/28/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import Foundation
import FirebaseUI
import CoreLocation
import MapKit



extension DescriptionViewController{
    
    
    func deleteFileAt(type: String, group: String, id: String){
        ref.child(type).child(group).child(id).removeValue()
    }
    
    
    
    
}
