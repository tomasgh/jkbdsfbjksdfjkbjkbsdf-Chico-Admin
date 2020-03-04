//
//  EditingViewController.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/24/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit
import FirebaseUI

class EditingViewController: UIViewController {
    
    var editSpot: Spot?
    let ref: DatabaseReference = Database.database().reference()
    func grabSpotInfo(){
        guard editSpot != nil else{
            dismiss(animated: true, completion: nil)
            return
        }
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
