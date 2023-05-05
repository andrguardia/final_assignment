//
//  ContentView.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/14/23.
//

import SwiftUI
import Charts
import Accelerate


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
            
            HStack{
                VStack(alignment: .leading){
                    Text("Band Structure Calculator")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.all, 50)
                    
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
                }
                
                Divider()
                VStack {
                    
                    Text("Results")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.all, 25)
                    
                    Text("Band Structure: \(selectedStructure.name)")
                        .font(.title2)
                    
                    HStack{
                        Spacer().frame(width: 100)
                        Text("E (eV))")
                            .font(.title3)
                            .rotationEffect(Angle(degrees: -90))
                        
                        Chart(result) {
                            PointMark(
                                x: .value("k-Point", $0.x),
                                y: .value("Eigenvalue", $0.y)
                            ).symbolSize(30.0)
                        }
                        .chartYAxis {
                            AxisMarks(values: .automatic(desiredCount: 10)){
                                AxisValueLabel(format: Decimal.FormatStyle.number)
                                AxisGridLine()
                            }
                            
                        }.chartYScale(domain: [0, 6])
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 10)){
                                AxisValueLabel(format: Decimal.FormatStyle.number)
                                AxisGridLine()
                            }
                        }.chartXScale(domain: [0, 1])
        
                        Spacer().frame(width: 100)
                    }

                    Text("k-Points")
                        .font(.title3)
                    Spacer().frame(height:50)
                    
                }
                
            }
            
        }
        


    }
    
    func calculate(){
        //we multiply all symmetric and assymetric factors by 13.6 to convert from rydbergs to eV
//        let symmetricFormfactors = [3: [13.6059*selectedStructure.pseudopotentialFormFactor_V3S], 8: [13.6059*selectedStructure.pseudopotentialFormFactor_V8S], 11: [13.6059*selectedStructure.pseudopotentialFormFactor_V11S]]
//        let asymmetricFormFactors = [3: [13.6059*selectedStructure.pseudopotentialFormFactor_V3A], 4: [13.6059*selectedStructure.pseudopotentialFormFactor_V4A], 11: [13.6059*selectedStructure.pseudopotentialFormFactor_V11A]]
        
        //LETS DEFINE SYMMETRIC AND ASYMMETRIC FACTORS SEPARATELY
        let ffS_3 = 13.6059*selectedStructure.pseudopotentialFormFactor_V3S
        let ffS_8 = 13.6059*selectedStructure.pseudopotentialFormFactor_V8S
        let ffS_11 = 13.6059*selectedStructure.pseudopotentialFormFactor_V11S
        let ffA_3 = 13.6059*selectedStructure.pseudopotentialFormFactor_V3A
        let ffA_4 = 13.6059*selectedStructure.pseudopotentialFormFactor_V4A
        let ffA_11 = 13.6059*selectedStructure.pseudopotentialFormFactor_V11A
        
        //In units of 2*pi/a
        let reciprocalBasis = [1.0, 1.0, -1.0,
                               1.0, -1.0, 1.0,
                               -1.0, 1.0, 1.0]
        
        let samplePoints = 100 // Sample Points per k-path
        
        // Basis vectors for reciprocal lattice in 2pi/a units
                
//        let h1 = [1.0, 1.0, -1.0]
//        let h2 = [1.0, -1.0, 1.0]
//        let h3 = [-1.0, 1.0, 1.0]
        
//        var n1 = 0, n2 = 0, n3 = 0
        
        // Tau (x,y,z) is the atomic basis vector
        let k_units = 2.0*Double.pi/selectedStructure.latticeVariable
        
        // tau = a(1/8,1/8,1/8)
//        let tau : [Double] = [1.0/8.0, 1.0/8.0, 1.0/8.0]

        // Symmetry directions: (in units of 2Pi/a)
        //      Point   k-vector
        //      _____   _______
        //      Gamma   (0,0,0)
        //      X       (0,0,1)
        //      L       (1/2,1/2,1/2)
        //      K       (3/4,0,3/4)
        
        //Initialize Symmetry Points in Brillouin zone:
        
        let LbaseVec = [0.5, 0.5, 0.5]
        let GbaseVec = [0.0, 0.0, 0.0]
        let XbaseVec = [0.0, 0.0, 1.0]
        let KbaseVec = [0.75, 0.0, 0.75]
        let UbaseVec = [0.25, 0.25, 1.0]

        // Number and list of k-vectors
        /// NEED TO LOOP THROUGH PROGRAM UNTIL ALL k VECTORS ARE ACCOUNTED FOR
                
        // Generate k-vector
        // Need enough k vector points in each direction to have a nice plot and find the minimum and maximum of each band
        
        
        var k_vecArray = [[Double]]() //Initialize K vector array
        // Doesn't include the units of 2pi/a until actualy k-vectors are generated
        //loop between each high symmetry points
        //Gamma = (0,0,0) and L = (.5,.5,.5)
        
        // L to Gamma
        var LGdiff = [0.0,0.0,0.0]
        vDSP_vsubD(LbaseVec, 1, GbaseVec, 1, &LGdiff, 1, 3)
        var xincrement = LGdiff[0] / Double(samplePoints)
        var yincrement = LGdiff[1] / Double(samplePoints)
        var zincrement = LGdiff[2] / Double(samplePoints)
        
        var k_vec = [0.0,0.0,0.0]
        
        for i in 0...(samplePoints-1) {
            
            let increment = Double(i)

            k_vec[0] = (LbaseVec[0] + xincrement * increment)
            k_vec[1] = (LbaseVec[1] + yincrement * increment)
            k_vec[2] = (LbaseVec[2] + zincrement * increment)
            k_vecArray.append([k_units*k_vec[0], k_units*k_vec[1], k_units*k_vec[2]])
        }
        
        // Gamma to X
        var GXdiff = [0.0,0.0,0.0]
        vDSP_vsubD(GbaseVec, 1, XbaseVec, 1, &GXdiff, 1, 3)
        xincrement = GXdiff[0]/Double(samplePoints)
        yincrement = GXdiff[1]/Double(samplePoints)
        zincrement = GXdiff[2]/Double(samplePoints)

        k_vec = [0.0,0.0,0.0]
        for i in 1...(samplePoints-1) {

            let inc = Double(i)

            k_vec[0] = (GbaseVec[0] + xincrement * inc)
            k_vec[1] = (GbaseVec[1] + yincrement * inc)
            k_vec[2] = (GbaseVec[2] + zincrement * inc)

            k_vecArray.append([k_vec[0], k_vec[1], k_vec[2]])
        }

        // X to U
        var XKdiff = [0.0,0.0,0.0]
        vDSP_vsubD(XbaseVec, 1, UbaseVec, 1, &XKdiff, 1, 3)
        xincrement = XKdiff[0] / Double(samplePoints/2)
        yincrement = XKdiff[1] / Double(samplePoints/2)
        zincrement = XKdiff[2] / Double(samplePoints/2)

        k_vec = [0.0,0.0,0.0]
        for i in 1...(samplePoints/2-1) {

            let inc = Double(i)
            k_vec[0] = (XbaseVec[0] + xincrement * inc)
            k_vec[1] = (XbaseVec[1] + yincrement * inc)
            k_vec[2] = (XbaseVec[2] + zincrement * inc)

            k_vecArray.append([k_vec[0], k_vec[1], k_vec[2]])
        }

        // K to G
        var KGdiff = [0.0,0.0,0.0]
        vDSP_vsubD(KbaseVec, 1, GbaseVec, 1, &KGdiff, 1, 3)
        xincrement = KGdiff[0] / 20.0
        yincrement = KGdiff[1] / 20.0
        zincrement = KGdiff[2] / 20.0

        k_vec = [0.0,0.0,0.0]
        for i in 1...(samplePoints-1) {

            let inc = Double(i)
            k_vec[0] = (KbaseVec[0] + xincrement * inc)
            k_vec[1] = (KbaseVec[1] + yincrement * inc)
            k_vec[2] = (KbaseVec[2] + zincrement * inc)

            k_vecArray.append([k_vec[0], k_vec[1], k_vec[2]])
        }
        
        //We now define Hamiltonian Object
        let myHammy = Hamiltonian()
        //We now define k-point path
        let path = k_vecArray
        print(path.count)
        

        let bands = myHammy.bandStructure(latticeConstant: selectedStructure.latticeVariable, ffS_3: ffS_3, ffS_8:ffS_8, ffS_11:ffS_11, ffA_3:ffA_3, ffA_4:ffA_4, ffA_11:ffA_11, reciprocalBasis: reciprocalBasis, states: 5, path: path)

        result = bands//.sorted(by: { $0.x < $1.x })
        

    }

    func clear(){
    }
    
//    func linpath(a: [Double], b: [Double], n: Int = 50, endpoint: Bool = true) -> [Double] {
//        // Create an array of n equally spaced points along the path a -> b, inclusive.
//
//        // Get the shortest length of either a or b
//
//
//        return points
//    }

    




}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
