//
//  ContentView.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/14/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedStructure = ("", 0.0)
    let structures = [("Si", 5.43), ("Other", 0.0)]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Band Structure Calculator")
                .font(.title)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            Text("This app was created by Andre Guardia as the final project for his PHYS 440 class. The app calculates the band structures for all 14 diamond and zincblende structures described in the paper: Band Structures and Pseudopotential Form Factors for Fourteen Semiconductors of the Diamond and Zinc-blende Structures by Marvin L. Cohen and T.K. Bergstresser")
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            
            Text("Select Material")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            HStack{
                Text("To use this calculator, please select a semiconductor structure from the dropdown menu:")
                    .padding(.leading, 50)
                    .padding(.trailing, 50)
                
                Picker(selection: $selectedStructure , label: Text("")) {
                    ForEach(0..<structures.count) { i in
                        Text(self.structures[i].0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 100)
            }
            
            Divider()
            
            Text("Results")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            Text("Band Structure:" + String(selectedStructure.0))
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            Text("Lattice Variable (a) in Angstroms:" + String(selectedStructure.1))
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            
        }
    }
}





func calculate(){
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
