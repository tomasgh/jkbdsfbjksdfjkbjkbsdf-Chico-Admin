//
//  AddingViewController.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 2/18/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import UIKit
import FirebaseUI

class AddingViewController: UIViewController {
    let ref: DatabaseReference = Database.database().reference()
    let type = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    var group = ["Other", "None"]
    var editingSpot: Spot?
    
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var LaditudeText: UITextField!
    @IBOutlet weak var LongitudeText: UITextField!
    @IBOutlet weak var TypePicker: UIPickerView!
    @IBOutlet weak var buttonConfirmation: UIButton!
    @IBOutlet weak var GroupPicker: UIPickerView!
    @IBOutlet weak var OtherTextField: UITextField!
    
    var typePicker: String?
    var groupPicker: String?
    var laditude: Double?
    var longitude: Double?
    
    @IBAction func Confirm(_ sender: UIButton) {
        if OtherTextField.isHidden == false{
            groupPicker = OtherTextField.text
        }
        performSegue(withIdentifier: "LastStepSegue", sender: self)
    }
    
    @IBOutlet weak var DeletButton: UIButton!
    @IBAction func deleteMessage(_ sender: Any) {
        
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to delete the location?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Yes", style: .destructive) { (alert) in
            self.deleteFileAt(type: self.editingSpot!.type!, group: self.editingSpot!.id!, id: self.editingSpot!.id!)
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "No Thank you", style: .cancel) { (alert) in
            
        }
        alert.addAction(action2)
        self.present(alert, animated: true) {
            
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let typeIndex = TypePicker.selectedRow(inComponent: 0)
        let groupIndex = GroupPicker.selectedRow(inComponent: 0)
        var mygroup = group[groupIndex]
        let mytype = type[typeIndex]
        if mygroup == "Other"{
            mygroup = OtherTextField.text ?? ""
        }
        
        guard let laditude = Double(LaditudeText.text!),
            let longitude = Double(LongitudeText.text!),
            let name = NameText.text else {return}
        
        let vc = segue.destination as! DescriptionViewController
        vc.name = name
        vc.longitude = longitude
        vc.laditude = laditude
        vc.type = mytype
        vc.group = mygroup
        vc.editingSpot = editingSpot
        
        guard let info = editingSpot?.info,
            let id = editingSpot?.id else {return}
        vc.id = id
        vc.infoText = info
        
        
    }
    
    
    func setupPicker(){
        TypePicker.tag = 0
        GroupPicker.tag = 1
        
        
        TypePicker.delegate = self
        GroupPicker.delegate = self
        guard let lad = laditude,
            let long = longitude else {return}
        LaditudeText.text = String(lad)
        LongitudeText.text = String(long)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupPicker()
        editingSetup()
        if editingSpot == nil{
            DeletButton.isHidden = true
        }
        else{
            DeletButton.isHidden = false
        }
    }
    func editingSetup(){
        if editingSpot != nil{
            //Selects Type if any
            let typeIndex = type.firstIndex { (string) -> Bool in
                return string == editingSpot?.type
            }
            guard let num = typeIndex else {return}
            TypePicker.selectRow(num, inComponent: 0, animated: true)
            TypePicker.reloadAllComponents()
            //Selects Group if True is true and Group has something
            let groupIndex = group.firstIndex { (string) -> Bool in
                return string == editingSpot?.group
            }
            guard let groupNum = groupIndex else {return}
            GroupPicker.selectRow(groupNum, inComponent: 0, animated: true)
            OtherTextField.isHidden = true
            TypePicker.reloadAllComponents()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NameText.text = editingSpot?.name
        
    }
    func deleteFileAt(type: String, group: String, id: String){
        ref.child(type).child(group).child(id).removeValue()
    }
}

extension AddingViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0{
            return 1
        }
        else{
            return 1
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return type.count
        }
        else{
            return group.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            self.typePicker = type[row]
        }
        else{
            self.groupPicker = group[row]
            if group[row] == "Other"{
                OtherTextField.isHidden = false
            }
            else{
                OtherTextField.isHidden = true
                 self.groupPicker = group[row]
            }
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return type[row]
        }
        else{
            return group[row]
        }
    }
 
}
