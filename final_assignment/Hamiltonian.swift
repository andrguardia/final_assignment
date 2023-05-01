//
//  Hamiltonian.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/27/23.
//

import SwiftUI
import Foundation
import Accelerate


var hbar = 1.0545718e-34 // Planck's constant divided by 2π in J/s
var m_e = 9.10938356e-31 // mass of the electron in Kg
var e = 1.602176634e-19 //electron charge in Coulombs


class Hamiltonian: NSObject {
    // Define constants
    var KINETIC_CONSTANT = pow(hbar, 2) / (2 * m_e * e) // Constant that multiplies the kinetic term in the Hamiltonian Matrix
    var N = 5.0 // Total number of states to be modeled
    
    //we start by calculating the reciprocal lattice basis vectors
    //These vectors are given by Our Hamiltonian matrix's size is given by the number of reciprocal lattice vectors (G → and G′→):
    //G = hb_1 + kb_2+lb_3
    // Where b_n is our reciprocal lattice basis and h,k, and l are a set of integers centered around zero.
    
    
    func coefficients(m: Int, states: Int) -> [Double] {
    //This function calculates the coefficients for the reciprocal lattice vectors
    //The function takes two integer parameters, m and states, and returns a [Double] of three integers. The Swift version uses integer division instead of floor division.
        
    //The function first calculates the total number of lattice sites, n, by raising the number of states to the power of three and dividing by two. Then, it calculates the sum s of m and n, and computes the indices h, k, and l by using integer division and modulo operations on s and the number of states. Finally, the function returns the array [h, k, l] containing the computed indices.
    // This implementation is Based on A. Danner (2004) in his implementation of this same problem in Mathematica: http://danner.group/pseudopotential.html
        
        let n = (states * states * states) / 2
        let s = m + n
        let floor = states / 2
        let h = Double(s / (states * states) - floor)
        let k = Double((s % (states * states)) / states - floor)
        let l = Double(s % states - floor)
        let coeff = [h, k, l]
        return coeff
    }

    
    //We proceed to calculate the kinetic term of the Hamiltonian.
    //                  Tij = hbar^2/(2m) * [[k+G]]^2 * δi,j
    //where i and j are our row and column indices, respectively, and δi,j is the Kronecker delta.
    //For k and Gi values in units of 2π/a. The kinetic term is given by:
    
    func kinetic(k: [Double], g: [Double]) -> Double {
        
        let v = zip(k, g).map { $0 + $1 }
        
        return KINETIC_CONSTANT * v.reduce(0, { $0 + pow($1, 2) })
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

    func hamiltonian(latticeConstant: Double, formFactorsS: [Double: [Double]], formFactorsA: [Double: [Double]], reciprocalBasis: [Double], k: [Double], states: Int) -> [[Complex<Double>]] {
        
        let a = latticeConstant
        let ffS = formFactorsS // Symmetric Form Factors
        let ffA = formFactorsA //Assymetric Form Factors from Zincblende structure
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
                    let g = [dot(coefficients(m: row - Int(n / 2), states: states),basis)]
                    // calculate the kinetic energy and assign it to the matrix
                    H[row][col] = Complex<Double>(real: kinetic_c * kinetic(k: k, g: g), imaginary: 0)
                } else{
                    // calculate the reciprocal lattice vector for this pair of rows and columns
                    let g = [dot(coefficients(m: row - col, states: states), basis)] //******Need to re-evaluate how this is being calculated!!!!!!1
                    
                    
                    if let symfactors = ffS[dot(g,g)], let asymfactors = ffA[dot(g,g)]{
                        // both symfactors and asymfactors exist for this key
                        H[row][col] = potential(g: g, tau: offset, sym: symfactors[0], asym: asymfactors[0])
                    }
                    else if let symfactors = ffS[dot(g,g)]{
                        // symfactors exist but asymfactors do not exist for this key
                        H[row][col] = potential(g: g, tau: offset, sym: symfactors[0], asym: 0.0)
                    }
                    else if let asymfactors = ffA[dot(g,g)]{
                        // asymfactors exist but symfactors do not exist for this key
                        H[row][col] = potential(g: g, tau: offset, sym: 0.0, asym: asymfactors[0])
                    }
                    else{
                        // both symfactors and asymfactors do not exist for this key
                        //                        H[row][col] = Complex<Double>(real: 0.0, imaginary: 0.0)
                    }
                }
            }
        }
        return H
    }
    
    
    func dot(_ a: [Double], _ b: [Double]) -> Double {
        return zip(a, b).map(*).reduce(0, +)
    }
    
    
    
    
    func bandStructure(latticeConstant: Double, formFactorS:[Double: [Double]], formFactorA:[Double: [Double]], reciprocalBasis:[Double], states:Int, path:[[Double]])-> [[Complex<Double>]] {
          
            var bands = [[Complex<Double>]]()
            
            for k in path {
                // loop body here
                let H = hamiltonian(latticeConstant: latticeConstant, formFactorsS: formFactorS, formFactorsA: formFactorA, reciprocalBasis: reciprocalBasis, k: k, states: states)
                //Need to find a way to compute eigenvalues for this one
                let eigenVals = computeEigenvalues(A: H)
                let sortedeigenVals = eigenVals.sorted { $0.real < $1.real }
                bands.append(Array(sortedeigenVals.prefix(120)))
            }
        
            return bands
        }

    
    
    func computeEigenvalues(A: [[Complex<Double>]]) -> [Complex<Double>] {
        var N = Int32(A.count) // number of rows/columns in matrix A
        
        // Create complex double array for eigenvalues
        var w = [__CLPK_doublecomplex](repeating: .init(), count: Int(N))
        
        // Create complex double array for matrix A
        var Aflat = Array(A.joined().map { unsafeBitCast($0, to: __CLPK_doublecomplex.self) })
        
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
