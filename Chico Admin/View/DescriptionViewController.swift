//
//  DescriptionViewController.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/19/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit
import FirebaseUI

class DescriptionViewController: UIViewController {
    let ref: DatabaseReference = Database.database().reference()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var laditudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var groupLabel: UILabel!
    
    var name: String?
    var laditude: Double?
    var longitude: Double?
    var type: String?
    var group: String?
    var infoText: String?
    var id: String?
    var editingSpot: Spot?
    var delete = false
    
    @IBOutlet weak var textField: UITextView!
    
    @IBAction func ConfirmButton(_ sender: UIButton){
        addItems()
        if let editS = editingSpot{
            deleteFileAt(type: editS.type!, group: editS.group!, id: editS.id!)
        }
        performSegue(withIdentifier: "unwind", sender: self)
    }
    
    @IBAction func DeleteButton(_ sender: UIButton) {
        guard type != nil,
            group != nil,
            id != nil else{return}
        
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete the location?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { (alert) in
            self.deleteFileAt(type: self.type!, group: self.group!, id: self.id!)
            self.delete = true
            self.performSegue(withIdentifier: "unwind", sender: self)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "No Thank you", style: .cancel) { (alert) in
            self.delete = false
        }
        alert.addAction(action2)
        self.present(alert, animated: true) {
            
        }
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwind"{
            if delete {
                let vc = segue.destination as! ViewController
                let overlay = vc.mapView.annotations.filter { (overlay) -> Bool in
                    return overlay.subtitle == id
                }
                guard let lay = overlay.first else {return}
                vc.mapView.removeAnnotation(lay)
                
            }
            
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard type != nil,
            group != nil,
            name != nil else {
                dismiss(animated: true, completion: nil)
                return
        }
        textField.text = infoText ?? ""
        nameLabel.text = name
        laditudeLabel.text = String(laditude ?? 0.0)
        longitudeLabel.text = String(longitude ?? 0.0)
        typeLabel.text = type
        groupLabel.text = group
        textField.layer.cornerRadius = 25
        
    }
    func addItems(){
        if infoText != nil{
            let addspot = [
                "name" : nameLabel.text!,
                "laditude" : Double(laditudeLabel.text!)!,
                "longitude" : Double(longitudeLabel.text!)!,
                "information": textField.text!
                ] as [String: Any]
            ref.child(type!).child(group!).child(id!).setValue(addspot) { (error, database) in
                if error != nil{
                    print("Error Adding message: \(String(describing: error))")
                }
            }
            
        }
        else{
            let addspot = [
                "name" : nameLabel.text!,
                "laditude" : Double(laditudeLabel.text!)!,
                "longitude" : Double(longitudeLabel.text!)!,
                "information": textField.text!
                ] as [String: Any]
            ref.child(type!).child(group!).childByAutoId().setValue(addspot) { (error, database) in
                if error != nil{
                    print("Error Adding message: \(String(describing: error))")
                }
            }
            
        }
        
        
    }
    
}
