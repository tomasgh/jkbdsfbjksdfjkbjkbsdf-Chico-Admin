//
//  AddingLocation.swift
//  Chico Admin
//
//  Created by Tomas Galvan-Huerta on 3/31/20.
//  Copyright © 2020 Somat. All rights reserved.
//

import SwiftUI
import CoreLocation
import Combine
import FirebaseUI

final class DataLocation: ObservableObject{
    var types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    @Published var Name: String = ""
    @Published var Laditude: Double = 0.0
    @Published var Longitude: Double = 0.0
    @Published var typeSelected: Int = 0
    @Published var groupSelected: Int = 0
    @Published var groups: [String] = []
    @Published var Description: String = ""
    var type: String{
        types[typeSelected]
    }
    var group: String{
        groups[groupSelected]
    }
    var coordinate: CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: Laditude, longitude: Longitude)
    }

}

//MARK: Start
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct AddingLocation: View {
    var types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    @ObservedObject var newSpot = DataLocation()
    @State var mylocation: CLLocationCoordinate2D
    @State var otherGroup: String = ""
    @State var loctionsisOn: Bool
    var dismissAction: (() -> Void)
    let ref: DatabaseReference = Database.database().reference()
    var body: some View {
        ScrollView{
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    NameLongLad(name: $newSpot.Name, Longitude: $newSpot.Longitude, Laditude: $newSpot.Laditude, type: $newSpot.typeSelected, AllGroups: $newSpot.groups, group: $newSpot.groupSelected)
                        .padding([.top, .leading])
                }

                VStack(alignment: .trailing){
                    Text("Editing")
                        .font(.largeTitle)
                        .multilineTextAlignment(.trailing)
                    .shadow(radius: 1)
                        .padding([.top, .trailing])
                }
            }
            .padding(.horizontal)
            MapViewConroller(Status: $loctionsisOn, mylocation: newSpot.coordinate, typeForPicture: $newSpot.typeSelected)
                .clipShape(Circle()).shadow(radius: 30)
                .scaledToFit()
            TextField("Name of location", text: $newSpot.Name)
                .padding(.leading, 17.0)
                .foregroundColor(.black)
            
            Typeof(groups: newSpot.groups, optionGroup: $otherGroup, partOfGroup: $newSpot.groupSelected, selected: $newSpot.typeSelected)
            Spacer()
            if newSpot.Laditude != 0.3 && newSpot.Name != "" {
                //Show all details again
                HStack(alignment: .top){
                    VStack(alignment: .leading){
                       if self.otherGroup != ""{
                        NameLongLadOptionGroup(name: $newSpot.Name, Longitude: $newSpot.Longitude, Laditude: $newSpot.Laditude, type: $newSpot.typeSelected, AllGroups: $newSpot.groups, group: self.$otherGroup)
                        .padding([.top, .leading])
                            
                       }else{
                            NameLongLad(name: $newSpot.Name, Longitude: $newSpot.Longitude, Laditude: $newSpot.Laditude, type: $newSpot.typeSelected, AllGroups: $newSpot.groups, group: $newSpot.groupSelected)
                        .padding([.top, .leading])
                        }
                        
                    }

                    VStack(alignment: .trailing){
                        Text("Final Look")
                            .font(.largeTitle)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.red)
                        .shadow(radius: 1)
                            .padding([.top, .trailing])
                    }
                }
                //Show Button
                HStack{
                    Button(action: {
                        var optionalGroup = self.newSpot.group
                        if self.otherGroup != ""{
                            optionalGroup = self.otherGroup
                        }
                        let addspot = [
                            "name" : self.newSpot.Name,
                            "laditude" : self.newSpot.Laditude,
                            "longitude" : self.newSpot.Longitude,
                            "information": ""
                            ] as [String: Any]
                        self.ref.child(self.newSpot.type).child(optionalGroup).childByAutoId().setValue(addspot) { (error, database) in
                            if error != nil{
                                print("Error Adding message: \(String(describing: error))")
                            }
                        }
                        self.dismissAction()
                    }) { () in
                        Text("Send")
                            .foregroundColor(Color.white)
                            .bold()
                        
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10).shadow(radius: 7)
                }
                
                Spacer()
            }
            
            
        }
        .background(Color(red: 1.012, green: 0.929, blue: 0.792))
            .edgesIgnoringSafeArea(.bottom)
        .font(.body).foregroundColor(.black)
    
    }

}
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//MARK: End View
struct debuggingmaps: View{
    @State var isaba = false
    @State var location = CLLocation(latitude: 23.1234, longitude: -123.242).coordinate
    var body: some View{
        AddingLocation(mylocation: location, loctionsisOn: isaba, dismissAction: {})
    }
}

struct AddingLocation_Previews: PreviewProvider {
    
    static var previews: some View {
        debuggingmaps()
    }

}

struct NameLongLad: View{
    let types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    @Binding var name: String
    @Binding var Longitude: Double
    @Binding var Laditude: Double
    @Binding var type: Int
    @Binding var AllGroups: [String]
    @Binding var group: Int
    
    
    var body: some View{
        Group{
        TextField("Name", text: $name)
        Text(String(Longitude))
        Text(String(Laditude))
        Text(types[type])
        Text(AllGroups[group])
        }
    }
}
struct NameLongLadOptionGroup: View{
    let types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    @Binding var name: String
    @Binding var Longitude: Double
    @Binding var Laditude: Double
    @Binding var type: Int
    @Binding var AllGroups: [String]
    @Binding var group: String
    
    
    var body: some View{
        Group{
        TextField("Name", text: $name)
        Text(String(Longitude))
        Text(String(Laditude))
        Text(types[type])
        Text(group)
        }
    }
}

struct Typeof: View {
    @State var groups: [String]
    @Binding var optionGroup: String
    @Binding var partOfGroup: Int
    @Binding var selected: Int
    let types = ["Building", "Stairs", "Bus Station","Warning", "Blue Lights", "Other"]
    var body: some View{
        VStack(alignment: .center){
            Picker(selection: $selected, label: Image("\(types[selected])")
                .resizable()
                .multilineTextAlignment(.center)
                .shadow(radius: 2)
                .scaledToFit()
                ) {
            ForEach(0 ..< types.count) {worn in
                Text(self.types[worn]).foregroundColor(.black).shadow(radius: 1).foregroundColor(.black)
            }
            }
            if !groups.isEmpty {
                if groups[partOfGroup] == "Other"{
                    TextField("Type the option", text: $optionGroup)
                }
                Picker(selection: $partOfGroup, label: Text(groups[partOfGroup])) {
                ForEach(0 ..< groups.count) {worn in
                    Text(self.groups[worn]).foregroundColor(.black).shadow(radius: 1).foregroundColor(.black)
                    
                }
                }
            }
            
            
            
            
        }
    }
}
struct BuildingOf: View{
    @Binding var typeofBui: String
    var body: some View{
        Text("Building of ")
    }
}
