//
//  ContentView.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/14/23.
//

import SwiftUI


struct Structure: Hashable {
    let name: String
    let latticeVariable: Double
    let pseudopotentialFormFactor_V3S: Double
    let pseudopotentialFormFactor_V8S: Double
    let pseudopotentialFormFactor_V11S: Double
    let pseudopotentialFormFactor_V3A: Double
    let pseudopotentialFormFactor_V4A: Double
    let pseudopotentialFormFactor_V11A: Double
}

struct ContentView: View {
    @State private var selectedStructure = Structure(name: "None Selected", latticeVariable: 0.00, pseudopotentialFormFactor_V3S:0.00, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.00, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00  )
    
    let structures = [
        
        Structure(name: "Si", latticeVariable: 5.43, pseudopotentialFormFactor_V3S:-0.21, pseudopotentialFormFactor_V8S: 0.04, pseudopotentialFormFactor_V11S: 0.08, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00  ),
        
        Structure(name: "Ge", latticeVariable: 5.66, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00  ),
        
        Structure(name: "Sn", latticeVariable: 6.49, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00  ),
        
        Structure(name: "GaP", latticeVariable: 5.44, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.03, pseudopotentialFormFactor_V11S: 0.07, pseudopotentialFormFactor_V3A: 0.12, pseudopotentialFormFactor_V4A:0.07, pseudopotentialFormFactor_V11A: 0.02  ),
        
        Structure(name: "GaAs", latticeVariable: 5.64, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.07, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01  ),
        
        Structure(name: "AlSb", latticeVariable: 6.13, pseudopotentialFormFactor_V3S:-0.21, pseudopotentialFormFactor_V8S: 0.02, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.04, pseudopotentialFormFactor_V11A: 0.02  ),

        Structure(name: "InP", latticeVariable: 5.86, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.07, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01  ),
        
        Structure(name: "GaSb", latticeVariable: 6.12, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01  ),
        
        Structure(name: "InAs", latticeVariable: 6.04, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.08, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.03  ),
        
        Structure(name: "InSb", latticeVariable: 6.48, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01  ),
        
        Structure(name: "ZnS", latticeVariable: 5.41, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.03, pseudopotentialFormFactor_V11S: 0.07, pseudopotentialFormFactor_V3A: 0.24, pseudopotentialFormFactor_V4A:0.14, pseudopotentialFormFactor_V11A: 0.04  ),
        
        Structure(name: "ZnSe", latticeVariable: 5.65, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.18, pseudopotentialFormFactor_V4A:0.12, pseudopotentialFormFactor_V11A: 0.03  ),
        
        Structure(name: "ZnTe", latticeVariable: 6.07, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.13, pseudopotentialFormFactor_V4A:0.10, pseudopotentialFormFactor_V11A: 0.01  ),

        Structure(name: "CdTe", latticeVariable: 6.41, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.15, pseudopotentialFormFactor_V4A:0.09, pseudopotentialFormFactor_V11A: 0.04  ),
    ]
    
    var body: some View {
        
        VStack(alignment: .center) {
            
            Text("Band Structure Calculator")
                .font(.title)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            Text("This app was created by Andre Guardia as the final project for his PHYS 440 class. The app calculates the band structures for all 14 diamond and zincblende structures described in the paper: Band Structures and Pseudopotential Form Factors for Fourteen Semiconductors of the Diamond and Zinc-blende Structures by Marvin L. Cohen and T.K. Bergstresser")
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
            
            Divider()
            
            Text("Select Material")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            Text("Please select a semiconductor structure from the dropdown menu:")
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Picker(selection: $selectedStructure, label: Text("")) {
                ForEach(structures, id: \.self) { structure in
                    Text(structure.name)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 100)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 5)

            Text("Band Structure: \(selectedStructure.name)")
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .padding(.top, 5)
            
            Text("Lattice Variable [Å]: \(selectedStructure.latticeVariable)")
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .padding(.top, 5)
            
            HStack{
                VStack{
                    Text("Pseudopotential Form Factor V3S: \(selectedStructure.pseudopotentialFormFactor_V3S)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                    
                    Text("Pseudopotential Form Factor V8S: \(selectedStructure.pseudopotentialFormFactor_V8S)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                    
                    Text("Pseudopotential Form Factor V11S: \(selectedStructure.pseudopotentialFormFactor_V11S)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                }.padding(.top, 25)
                VStack{
                    Text("Pseudopotential Form Factor V3A: \(selectedStructure.pseudopotentialFormFactor_V3A)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                    
                    Text("Pseudopotential Form Factor V4A: \(selectedStructure.pseudopotentialFormFactor_V4A)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                    
                    Text("Pseudopotential Form Factor V11A: \(selectedStructure.pseudopotentialFormFactor_V11A)")
                        .multilineTextAlignment(.leading)
                        .padding(.leading, 50)
                        .padding(.trailing, 50)
                        .padding(.top, 5)
                }.padding(.top, 25)
            }
            
            
            
            HStack{
                Button(action: {calculate()}) {
                    Text("Calculate")
                }
                .padding(.trailing, 50)
                
                Button(action: {clear()}) {
                    Text("Clear")
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 25)

            
        }
    }
    
    func calculate(){
        
        let symmetricFormfactors = [3.0: [selectedStructure.pseudopotentialFormFactor_V3S], 8.0: [selectedStructure.pseudopotentialFormFactor_V8S], 11.0: [selectedStructure.pseudopotentialFormFactor_V11S]]
        let asymmetricFormFactors = [3.0: [selectedStructure.pseudopotentialFormFactor_V3A], 4.0: [selectedStructure.pseudopotentialFormFactor_V4A], 11.0: [selectedStructure.pseudopotentialFormFactor_V11A]]
        
        //In units of 2*pi/a
        let reciprocalBasis = [-1.0, 1.0, 1.0,
                               1.0, -1.0, 1.0,
                               1.0, 1.0, -1.0]
        
        var samplePoints = 100 // Sample Points per k-path
        
        //Initialize Symmetry Points in Brillouin zone:
        
        let G = [0.0, 0.0, 0.0]
        let L = [0.5, 0.5, 0.5]
        let K = [0.75, 0.75, 0.0]
        let X = [0.0, 0.0, 1.0]
        let W = [1.0, 0.5, 0.0]
        let U = [0.25, 0.25, 1.0]

        // We now define the k-paths
        let lambd = linpath(a: L, b: G, n: samplePoints, endpoint: false)
        let delta = linpath(a: G, b: X, n: samplePoints, endpoint: false)
        let x_uk = linpath(a: X, b: U, n: samplePoints/4, endpoint: false)
        let sigma = linpath(a: K, b: G, n: samplePoints, endpoint: true)
        
        //Below we run the actual calculation of the band structure, making use of the high symmetry of the diamond lattice with a path
        // L → Γ → X → U / K → Γ
        
        var myHammy = Hamiltonian() //We define Hamiltonian Object
        let path = [lambd, delta, x_uk, sigma]
        
        var bands = myHammy.bandStructure(latticeConstant: selectedStructure.latticeVariable, formFactorS: symmetricFormfactors, formFactorA: asymmetricFormFactors, reciprocalBasis: reciprocalBasis, states: 5, path: path)
        
        print(bands)
        
        
    }

    func clear(){
        print("Clear button works lmao")
    }
    
    func linpath(a: [Double], b: [Double], n: Int = 50, endpoint: Bool = true) -> [Double] {
        // Create an array of n equally spaced points along the path a -> b, inclusive.

        // Get the shortest length of either a or b
        let k = min(a.count, b.count)
        
        // Calculate the step size for each dimension
        let step = (0..<k).map { (b[$0] - a[$0]) / Double(n - 1) }
        
        // Calculate the points along the path
        var points = (0..<n).map { i in
            (0..<k).map { j in
                a[j] + step[j] * Double(i)
            }
        }
        
        // Add the endpoint if necessary
        if endpoint && n > 1 {
            points[n-1] = b
        }
        
        // Flatten the points array and return it
        return points.flatMap { $0 }
    }

}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
