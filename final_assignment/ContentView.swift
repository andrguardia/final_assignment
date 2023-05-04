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



struct ContentView: View {
    @State private var selectedStructure = Structure(name: "None Selected", latticeVariable: 0.00, pseudopotentialFormFactor_V3S:0.00, pseudopotentialFormFactor_V8S: 0.00, pseudopotentialFormFactor_V11S: 0.00, pseudopotentialFormFactor_V3A: 0.00, pseudopotentialFormFactor_V4A:0.00, pseudopotentialFormFactor_V11A: 0.00)
    
    @State var result = [CGPoint]()
    
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
            
            VStack {
                Text("Band Structure: \(selectedStructure.name)")
                    .font(.title)
                    .padding(.top, 20)
                
                HStack{
                    Text("Energy [eV]")
                        .font(.title3)
                        .rotationEffect(Angle(degrees: -90))
                    
                    Chart(result) {
                        PointMark(
                            x: .value("k-Point", $0.x),
                            y: .value("Eigenvalue", $0.y)
                        )
                    }.chartYAxis {
                        AxisMarks(values: .automatic(desiredCount: 10))
                    }.chartXAxis {
                        AxisMarks(values: .automatic(desiredCount: 10))
                    }
                    Spacer().frame(width: 70)
                }
                Text("k-Points")
                    .font(.title3)
                Spacer().frame(height:25)
                
            }
            
        }


    }
    
    func calculate(){
        //we multiply all symmetric and assymetric factors by 13.6 to convert from rydbergs to eV
        let symmetricFormfactors = [3: [13.6059*selectedStructure.pseudopotentialFormFactor_V3S], 8: [13.6059*selectedStructure.pseudopotentialFormFactor_V8S], 11: [13.6059*selectedStructure.pseudopotentialFormFactor_V11S]]
        let asymmetricFormFactors = [3: [13.6059*selectedStructure.pseudopotentialFormFactor_V3A], 4: [13.6059*selectedStructure.pseudopotentialFormFactor_V4A], 11: [13.6059*selectedStructure.pseudopotentialFormFactor_V11A]]
        
        //LETS DEFINE SYMMETRIC AND ASYMMETRIC FACTORS SEPARATELY
        var ffS_3 = 13.6059*selectedStructure.pseudopotentialFormFactor_V3S
        var ffS_8 = 13.6059*selectedStructure.pseudopotentialFormFactor_V8S
        var ffS_11 = 13.6059*selectedStructure.pseudopotentialFormFactor_V11S
        var ffA_3 = 13.6059*selectedStructure.pseudopotentialFormFactor_V3A
        var ffA_4 = 13.6059*selectedStructure.pseudopotentialFormFactor_V4A
        var ffA_11 = 13.6059*selectedStructure.pseudopotentialFormFactor_V11A
        
        //In units of 2*pi/a
        let reciprocalBasis = [2*Double.pi/selectedStructure.latticeVariable, -2*Double.pi/selectedStructure.latticeVariable, 2*Double.pi/selectedStructure.latticeVariable,
                               2*Double.pi/selectedStructure.latticeVariable, 2*Double.pi/selectedStructure.latticeVariable, -2*Double.pi/selectedStructure.latticeVariable,
                               -2*Double.pi/selectedStructure.latticeVariable, 2*Double.pi/selectedStructure.latticeVariable, 2*Double.pi/selectedStructure.latticeVariable] //2*Double.pi/selectedStructure.latticeVariable  ADD THIS
        
        let samplePoints = 50 // Sample Points per k-path
        
        //Initialize Symmetry Points in Brillouin zone:
        
        let G = [0.0, 0.0, 0.0]
        let X = [0.0, 0.5, 0.5]
        let L = [0.5, 0.5, 0.5]
        let U = [0.25, 0.625, 0.625]
        let K = [0.375, 0.75, 0.375]
        

        // We now define the k-paths
        let lambd = linpath(a: L, b: G, n: samplePoints, endpoint: false)
        let delta = linpath(a: G, b: X, n: samplePoints, endpoint: false)
        let x_uk = linpath(a: X, b: K, n: samplePoints, endpoint: false)
        let sigma = linpath(a: K, b: G, n: samplePoints, endpoint: true)
        
        //let lambda = linpath(a: G, b: G, n: samplePoints, endpoint: true)

        //Below we run the actual calculation of the band structure, making use of the high symmetry of the diamond lattice with a path
        // L → Γ → X → U / K → Γ

        let myHammy = Hamiltonian() //We define Hamiltonian Object
        let path = lambd + delta + x_uk + sigma // Merge all paths into one array
        
        let bands = myHammy.bandStructure(latticeConstant: selectedStructure.latticeVariable, ffS_3: ffS_3, ffS_8:ffS_8, ffS_11:ffS_11, ffA_3:ffA_3, ffA_4:ffA_4, ffA_11:ffA_11, reciprocalBasis: reciprocalBasis, states: 5, path: path)
    
        result = bands//.sorted(by: { $0.x < $1.x })
        

    }

    func clear(){
    }
    
    func linpath(a: [Double], b: [Double], n: Int = 50, endpoint: Bool = true) -> [Double] {
        // Create an array of n equally spaced points along the path a -> b, inclusive.

        // Get the shortest length of either a or b
        let k = min(a.count, b.count)

        // Calculate the step size for each dimension
        let step = (0..<k).map { (b[$0] - a[$0]) / Double(n) }

        // Calculate the points along the path
        var points = [Double]()
        for i in stride(from: 0.0, to: Double(n), by: 1.0) {
            let p = (0..<k).map { j in
                a[j] + step[j] * i
            }
            points.append(contentsOf: p)
        }

        // Add the endpoint if necessary
        if endpoint && n > 1 {
            points.replaceSubrange((n-1)*k..<(n*k), with: b)
        }

        return points
    }





}

func removeDuplicates(from points: [CGPoint]) -> [CGPoint] {
    var uniquePoints = [CGPoint]()
    for point in points {
        if let index = uniquePoints.firstIndex(where: { $0.x == point.x }) {
            uniquePoints[index] = point
        } else {
            uniquePoints.append(point)
        }
    }
    return uniquePoints
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
