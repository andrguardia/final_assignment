//
//  ContentView.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/14/23.
//

import SwiftUI
import Charts


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

//struct bandPath: Identifiable {
//    //The Band data structure is used to plot the different segments in the Brillouin Zone for a particular element
//    //This data structure has three different fields: pathName, x and y with the following data types Double, [Double] and [Double] respectively.
//    //This data structure will be used for plotting the different band structures while also color coding each path in the Brillouin Zone
//    var id = UUID() // Add random id to conform with identifiable protocol so we can plot usin gcharts
//    var pathName: String //The name of the Brillouin Zone
//    var x: [Double] //The linspace output for the path of the same name
//    var y: [Double] //The actual eigenvalues for that path
//
//    init(pathName: String, x: [Double], y: [Double]) {
//            self.pathName = pathName
//            self.x = x
//            self.y = y
//        }
//
//}

struct ContentView: View {
    @State private var selectedStructure = Structure(name: "None Selected", latticeVariable: 0.00, pseudopotentialFormFactor_V3S:0.00, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.00, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00)
    
    @State var plotData: [[String: Any]] = []
    
    @State var result = [[Double]]()
    
    let structures = [
        
        Structure(name: "Si", latticeVariable: 5.43, pseudopotentialFormFactor_V3S:-0.21, pseudopotentialFormFactor_V8S: 0.04, pseudopotentialFormFactor_V11S: 0.08, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00),
        
        Structure(name: "Ge", latticeVariable: 5.66, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00 ),
        
        Structure(name: "Sn", latticeVariable: 6.49, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00 ),
        
        Structure(name: "GaP", latticeVariable: 5.44, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.03, pseudopotentialFormFactor_V11S: 0.07, pseudopotentialFormFactor_V3A: 0.12, pseudopotentialFormFactor_V4A:0.07, pseudopotentialFormFactor_V11A: 0.02 ),
        
        Structure(name: "GaAs", latticeVariable: 5.64, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.07, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01 ),
        
        Structure(name: "AlSb", latticeVariable: 6.13, pseudopotentialFormFactor_V3S:-0.21, pseudopotentialFormFactor_V8S: 0.02, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.04, pseudopotentialFormFactor_V11A: 0.02 ),

        Structure(name: "InP", latticeVariable: 5.86, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.07, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01 ),
        
        Structure(name: "GaSb", latticeVariable: 6.12, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01 ),
        
        Structure(name: "InAs", latticeVariable: 6.04, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.08, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.03 ),
        
        Structure(name: "InSb", latticeVariable: 6.48, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.06, pseudopotentialFormFactor_V4A:0.05, pseudopotentialFormFactor_V11A: 0.01 ),
        
        Structure(name: "ZnS", latticeVariable: 5.41, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.03, pseudopotentialFormFactor_V11S: 0.07, pseudopotentialFormFactor_V3A: 0.24, pseudopotentialFormFactor_V4A:0.14, pseudopotentialFormFactor_V11A: 0.04 ),
        
        Structure(name: "ZnSe", latticeVariable: 5.65, pseudopotentialFormFactor_V3S:-0.23, pseudopotentialFormFactor_V8S: 0.01, pseudopotentialFormFactor_V11S: 0.06, pseudopotentialFormFactor_V3A: 0.18, pseudopotentialFormFactor_V4A:0.12, pseudopotentialFormFactor_V11A: 0.03 ),
        
        Structure(name: "ZnTe", latticeVariable: 6.07, pseudopotentialFormFactor_V3S:-0.22, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.05, pseudopotentialFormFactor_V3A: 0.13, pseudopotentialFormFactor_V4A:0.10, pseudopotentialFormFactor_V11A: 0.01 ),

        Structure(name: "CdTe", latticeVariable: 6.41, pseudopotentialFormFactor_V3S:-0.20, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.04, pseudopotentialFormFactor_V3A: 0.15, pseudopotentialFormFactor_V4A:0.09, pseudopotentialFormFactor_V11A: 0.04 ),
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
            Divider()
            
        }
        
        VStack(alignment: .center){
            Text("Results")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.all, 25)
            
            let eigenvaluesString = result.map { $0.map { String($0) }.joined(separator: ", ") }
                                           .joined(separator: "\n")
            Text("Eigenvalues:\n\(eigenvaluesString)")
                .multilineTextAlignment(.leading)
                .padding(.leading, 50)
                .padding(.trailing, 50)
                .padding(.top, 5)
            
//            Chart(plotData){
//                LineMark(
//                    x: .value("k-Path", $0.x),
//                    y: .value("Energy [eV]", $0.y)
//                )
//            }
        }


    }
    
    func calculate(){
        
        let symmetricFormfactors = [Double(3): [selectedStructure.pseudopotentialFormFactor_V3S], Double(8): [selectedStructure.pseudopotentialFormFactor_V8S], Double(11): [selectedStructure.pseudopotentialFormFactor_V11S]]
        let asymmetricFormFactors = [Double(3): [selectedStructure.pseudopotentialFormFactor_V3A], Double(4): [selectedStructure.pseudopotentialFormFactor_V4A], Double(11): [selectedStructure.pseudopotentialFormFactor_V11A]]
        
        //In units of 2*pi/a
        let reciprocalBasis = [-1.0, 1.0, 1.0,
                               1.0, -1.0, 1.0,
                               1.0, 1.0, -1.0]
        
        let samplePoints = 100 // Sample Points per k-path
        
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
        let x_uk = linpath(a: X, b: U, n: samplePoints, endpoint: false)
        let sigma = linpath(a: K, b: G, n: samplePoints, endpoint: true)
        
        //Below we run the actual calculation of the band structure, making use of the high symmetry of the diamond lattice with a path
        // L → Γ → X → U / K → Γ
        
        let myHammy = Hamiltonian() //We define Hamiltonian Object
        let path = [lambd, delta, x_uk, sigma]
        
        let bands = myHammy.bandStructure(latticeConstant: selectedStructure.latticeVariable, formFactorS: symmetricFormfactors, formFactorA: asymmetricFormFactors, reciprocalBasis: reciprocalBasis, states: 5, path: path)
    
        
        let doubleBands = bands.map { $0.map { $0.real } }
        
        result = doubleBands
        
        //We now add the results per path to the plotData dictionary
        plotData.append(["pathName": "lambd", "x": lambd, "y": result[0]])
        plotData.append(["pathName": "delta", "x": delta, "y": result[1]])
        plotData.append(["pathName": "x_uk", "x": x_uk, "y": result[2]])
        plotData.append(["pathName": "sigma", "x": sigma, "y": result[3]])
        
        print(result[0].count)
        print(lambd.count)
        print(result[1].count)
        print(delta.count)
        print(result[2].count)
        print(x_uk.count)
        print(result[3].count)
        print(sigma.count)
        print("*********")


        
        
        
    }

    func clear(){
        print(plotData)
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
