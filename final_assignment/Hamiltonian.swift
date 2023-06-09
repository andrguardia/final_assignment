//
//  Hamiltonian.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/27/23.
//

import SwiftUI
import Foundation
import Accelerate


var hbar = 6.582119569e-16 // Planck's reduced constant in ev*S
var m_e = 8.187e-14 // mass of the electron in ev/c^2
var e = 1.602176634e-19 //electron charge in Coulombs



class Hamiltonian: NSObject {
    // Define constants
    var KINETIC_CONSTANT = pow(hbar, 2) / (2 * m_e * e) // Constant that multiplies the kinetic term in the Hamiltonian Matrix of units units of eV * meter^2 / Coulombs^2.
    var N = 5 // Total number of states to be modeled
    
    
    //we start by calculating the reciprocal lattice basis vectors
    //These vectors are given by Our Hamiltonian matrix's size is given by the number of reciprocal lattice vectors (G → and G′→):
    //G = hb_1 + kb_2+lb_3
    // Where b_n is our reciprocal lattice basis and h,k, and l are a set of integers centered around zero.
    
        
    func coefficients(m: Int, states: Int, latticeConstant: Double) -> [Double] {
        //This function calculates the coefficients for the reciprocal lattice vectors
        //The function takes two integer parameters, m and states, and returns a [Double] of three integers.
            
        //The function first calculates the total number of lattice sites, n, by raising the number of states to the power of three and dividing by two. Then, it calculates the sum s of m and n, and computes the indices h, k, and l by using integer division and modulo operations on s and the number of states. Finally, the function returns the array [h, k, l] containing the computed indices.
        var coeff = [Double]()
        let n = (states * states * states) / 2
        let s = m + n
        let floor = states / 2
        
        let h = Double(s / (states * states) - floor)
        let k = Double((s % (states * states)) / states - floor)
        let l = Double(s % states - floor)
        
        let pi = Double.pi
        let a = latticeConstant * Double(states)
        let b = 2 * pi / a
            
        let hRecip = Double(h) * b
        let kRecip = Double(k) * b
        let lRecip = Double(l) * b
        
        coeff.append(hRecip)
        coeff.append(kRecip)
        coeff.append(lRecip)
        
        return coeff
    }
    
    func calculateG(coeff: [Double], basis: [Double]) -> [Double] {
        //This function is used to perform matrix-vector multiplication to generate the reciprocal basis vector G. We start by defining G as an empty array of Doubles
        var g = [Double]()
        //We iterate over the basis matrix and perform dot product operations between the coefficients vector and each row vector in the basis matrix
        for i in 0..<3 {
            let row = [basis[i], basis[i+3], basis[i+6]] // Extracting the ith row of the matrix
            let dotProduct = zip(row, coeff).map(*).reduce(0, +) // Calculating the dot product between the row and the coefficient vector
            g.append(dotProduct)
        }
        return g
    }


    
    //We proceed to calculate the kinetic term of the Hamiltonian.
    //                  Tij = hbar^2/(2m) * [[k+G]]^2 * δi,j
    //where i and j are our row and column indices, respectively, and δi,j is the Kronecker delta.
    //For k and Gi values in units of 2π/a. The kinetic term is given by:
    
    func kinetic(k: [Double], g: [Double]) -> Double {
        
        let v = zip(k, g).map { $0 + $1 }
        
        return KINETIC_CONSTANT * v.reduce(0, {$0 + pow($1, 2)})
    }
    
    //With two atoms in the unit cell of the diamond (or zincblende) lattice our potential component must include both of their contributions. As per Cohen and Bergstresser choose an origin halfway between the two atoms, both situated at::
    
    //                                                          r_1 = a/8 * [1, 1, 1] = τ
    //                                                          r_2 = - τ
    
    //Potential is then given by:
    
    //                                                          Vi,j = VSG cos(G)•τ + iVAG sin(G)•τ
    
    // Where VSG and VAG represent the symmetrical and assymetrical value potentials for each crystalline structure. For zincblende structures particularly we have non-zero VAG terms, giving us a complex matrix that needs to be handled carefully in Swift implementation...
    
    func potential(g: [Double], tau: [Double], sym: Double, asym: Double) -> Complex<Double> {
        
        // create a Complex<Double> instance with imaginary value of 1
        let complexMultiplier: Complex<Double> = .i
        
        // calculate the real part of the potential
        let realPart = sym * cos(2 * Double.pi * (g + tau).reduce(0, +))
        
        // calculate the imaginary part of the potential
        let imagPart = asym * sin(2 * Double.pi * (g + tau).reduce(0, +))
        
        // multiply the real and imaginary parts with the complexMultiplier and return the resulting complex number
        return Complex<Double>(real: realPart, imaginary: imagPart)*complexMultiplier
    }

    func hamiltonian(latticeConstant: Double, ffS_3: Double, ffS_8:Double, ffS_11:Double, ffA_3:Double, ffA_4:Double, ffA_11:Double, reciprocalBasis: [Double], k: [Double], states: Int) -> [[Complex<Double>]] {
        
        let a = latticeConstant
        let basis = reciprocalBasis
        
        // some constants that don't need to be recalculated
        let kinetic_c = pow(2 * Double.pi / a, 2)
        let offset: [Double] = [0.125, 0.125, 0.125]
        
        // states determines size of matrix
        // each of the three reciprocal lattice vectors can
        // take on this many states, centered around zero
        // resulting in an n^3 x n^3 matrix
        let n = pow(Double(states), 3)
        
        // initialize our matrix to arbitrary elements
        var H = Array(repeating: Array(repeating: Complex<Double>(real: 0.0, imaginary: 0.0), count: Int(n)), count: Int(n))
        
        // iterate over each row and column of the matrix
        for row in 0..<Int(n) {
            for col in 0..<Int(n) {
                
                // if row and column index are the same, calculate kinetic energy
                if row == col {
                    // calculate the reciprocal lattice vector for this row
                    let coeffs = coefficients(m: row - Int(n/2), states: N, latticeConstant: latticeConstant)
                    let g = calculateG(coeff: coeffs, basis: basis) // Multiplying the coefficient vector with the basis matrix to obtain the resulting vector g
                    
                    // calculate the kinetic energy and assign it to the matrix
                    H[row][col] = Complex<Double>(real: kinetic_c * kinetic(k: k, g: g), imaginary: 0.0)
                } else{
                    // calculate the reciprocal lattice vector for this pair of rows and columns
    
                    let coeffs = coefficients(m: row - col, states: N, latticeConstant: latticeConstant)
                    
                    let g = calculateG(coeff: coeffs, basis: basis) // Multiplying the coefficient vector with the basis matrix to obtain the resulting vector g
                    
                    if Int(dot(g,g))==3{
                        H[row][col] = potential(g: g, tau: offset, sym: ffS_3, asym: ffA_3)
                    }
                    else if Int(dot(g,g))==8{
                        H[row][col] = potential(g: g, tau: offset, sym: ffS_8, asym: 0.0)
                    }
                    else if Int(dot(g,g))==11{
                        H[row][col] = potential(g: g, tau: offset, sym: ffS_11, asym: ffA_11)
                    }
                    else if Int(dot(g,g))==4{
                        H[row][col] = potential(g: g, tau: offset, sym: 0.0, asym: ffA_4)
                    }
                    else{
                        H[row][col] = Complex<Double>(real: 0.0, imaginary: 0.0)
                    }
                }
            }
        }
        return H
    }
    
    
    func dot(_ a: [Double], _ b: [Double]) -> Double {
        return zip(a, b).map(*).reduce(0, +)
    }
    
    
    

    
    func bandStructure(latticeConstant: Double, ffS_3: Double, ffS_8:Double, ffS_11:Double, ffA_3:Double, ffA_4:Double, ffA_11:Double, reciprocalBasis: [Double], states: Int, path: [[Double]]) -> [CGPoint] {
        // Initialize empty array of tuples to store (k, eigenvalue) pairs
        var data = [CGPoint]()
        
        // Loop over each k-point in the path
        for i in path {
            // Compute the Hamiltonian for this k-point
            let H = hamiltonian(latticeConstant: latticeConstant, ffS_3: ffS_3, ffS_8:ffS_8, ffS_11:ffS_11, ffA_3:ffA_3, ffA_4:ffA_4, ffA_11:ffA_11, reciprocalBasis: reciprocalBasis, k: i, states: states)
            
            // Compute the eigenvalues of the Hamiltonian
            let eigenVals = computeEigenvalues(A: H)
            
            let minEigenVal = eigenVals.sorted { $0.real < $1.real }
                                       .filter { $0.real >= -6 && $0.real <= 6 }
                                       .prefix(10)
            
            //We represent the magnitude of the k vector as k dot k
//            // Loop over each eigenvalue and add it to the bands array along with its corresponding k-point
            for eig in minEigenVal {
                data.append(CGPoint(x:dot(i,i), y:eig.real))
            }
        }
        
        // Return the array of (k, eigenvalue) pairs
        return data
    }
    
    
    func computeEigenvalues(A: [[Complex<Double>]]) -> [Complex<Double>] {
        var N = Int32(A.count) // number of rows/columns in matrix A
        
        // Create complex double array for eigenvalues
        var w = [__CLPK_doublecomplex](repeating: .init(), count: Int(N))

        // Transpose A for the zgeev method since it takes a matrix of the form (cols),(rows)
        var AT = A
        for i in 0..<Int(N) {
            for j in 0..<i {
                let temp = AT[i][j]
                AT[i][j] = AT[j][i]
                AT[j][i] = temp
            }
        }

        // Create complex double array for matrix A
        var Aflat = Array(AT.joined().map { unsafeBitCast($0, to: __CLPK_doublecomplex.self) })
        // Use UnsafeMutablePointer to get pointers to arrays for passing to ZGEEV function
        var jobvl: Int8 = 78 // ASCII code for 'N', indicating that left eigenvectors will not be computed
        var jobvr: Int8 = 86 // ASCII code for 'V', indicating that right eigenvectors will be computed
        var lda = N // leading dimension of A
        var ldvl = N // leading dimension of left eigenvectors (not used)
        var ldvr = N // leading dimension of right eigenvectors
        var lwork = __CLPK_integer(-1) // ask ZGEEV to return optimal workspace size
        var info: __CLPK_integer = 0 // integer flag for error reporting
        
        // Compute optimal workspace size
        // Compute optimal workspace size
        var work = [__CLPK_doublecomplex]()
        var rwork = [__CLPK_doublereal](repeating: 0.0, count: Int(2*N))
        var vl = [__CLPK_doublecomplex](repeating: .init(), count: Int(ldvl*N))
        var vr = [__CLPK_doublecomplex](repeating: .init(), count: Int(ldvr*N))

        // Call ZGEEV with lwork = -1 to get optimal workspace size
        var query = __CLPK_doublecomplex()
        zgeev_(&jobvl, &jobvr, &N, &Aflat, &lda, &w, &vl, &ldvl, &vr, &ldvr, &query, &lwork, &rwork, &info)

        if info == 0 {
            // Compute eigenvalues with optimal workspace size
            var lwork = __CLPK_integer(query.r)
            work = [__CLPK_doublecomplex](repeating: .init(), count: Int(lwork))
            zgeev_(&jobvl, &jobvr, &N, &Aflat, &lda, &w, &vl, &ldvl, &vr, &ldvr, &work, &lwork, &rwork, &info)
            
            // Convert real and imaginary parts of eigenvalues to Complex<Double>
            var eigenvalues = [Complex<Double>]()
            for i in 0..<Int(N) {
                eigenvalues.append(Complex<Double>(real: w[i].r, imaginary: w[i].i))
            }
            return eigenvalues
        } else {
            print("ZGEEV failed with info = \(info)")
            return []
        }
    }
}


// This is a struct called "Complex" that takes a generic type "T", which must conform to the "FloatingPoint" protocol.
struct Complex<T: FloatingPoint>: CustomStringConvertible {
    // The struct has two properties, "real" and "imaginary", of type T.
    var real: T
    var imaginary: T

    // This is the initializer for the struct that takes two parameters, "real" and "imaginary", and sets them to the corresponding properties.
    init(real: T, imaginary: T) {
        self.real = real
        self.imaginary = imaginary
    }

    // This is a computed property that returns a string representation of the complex number.
    // If the imaginary part is greater than or equal to 0, it returns a string in the format "real+imaginary i".
    // If the imaginary part is less than 0, it returns a string in the format "real-|imaginary| i".
    var description: String {
        if imaginary >= 0 {
            return "\(real)+\(imaginary)i"
        } else {
            return "\(real)-\(abs(imaginary))i"
        }
    }

    // This is a static property that returns an instance of the "Complex" struct with a real value of 0 and an imaginary value of 1.
    static var i: Complex<T> {
        return Complex<T>(real: 0, imaginary: 1)
    }

    // This is a static function that overloads the "*" operator for two instances of the "Complex" struct.
    // It performs complex multiplication and returns the resulting complex number.
    static func * (lhs: Complex<T>, rhs: Complex<T>) -> Complex<T> {
            let real = lhs.real * rhs.real - lhs.imaginary * rhs.imaginary
            let imaginary = lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
            return Complex<T>(real: real, imaginary: imaginary)
        }
}

struct CGPoint: Identifiable {
    var id = UUID()
    var x: Double
    var y: Double

    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
