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
    
    func coefficients(m: Int, states: Int) -> (Int, Int, Int) {
        //This function calculates the coefficients for the reciprocal lattice vectors
        //The function takes two integer parameters, m and states, and returns a tuple of three integers. The Swift version uses integer division instead of floor division and the tuple is enclosed in parentheses instead of commas.
        let n = (states*states*states) / 2
        let s = m + n
        let floor = states / 2

        let h = s / (states*states) - floor
        let k = (s % (states*states)) / states - floor
        let l = s % states - floor

        return (h, k, l)
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
    
    func potential(g: [Double], tau: [Double], sym: Double, asym: Double = 0) -> Complex<Double> {
        
        // create a Complex<Double> instance with imaginary value of 1
        let complexMultiplier: Complex<Double> = .i
        
        // calculate the real part of the potential
        let realPart = sym * cos(2 * Double.pi * (g + tau).reduce(0, +))
        
        // calculate the imaginary part of the potential
        let imagPart = asym * sin(2 * Double.pi * (g + tau).reduce(0, +))
        
        // multiply the real and imaginary parts with the complexMultiplier and return the resulting complex number
        return Complex<Double>(real: realPart, imaginary: imagPart) * complexMultiplier
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







//
//
//// Diagonalize the Hamiltonian matrix
//var eigVals = [Double](repeating: 0.0, count: N)
//var eigVecs = Matrix(size: (N, N), repeatedValue: 0.0)
//let info = LAPACKE_dsyevd(LAPACK_COL_MAJOR, "V", "U", N, &H, N, &eigVals)
//for n in 0..<N {
//    for m in 0..<N {
//        eigVecs[n, m] = H[m, n]
//    }
//}
//
//// Print the energy levels
//print("Energy levels:")
//for n in 0..<N {
//    print("\(n+1) \t \(eigVals[n] / 1.6e-19) eV")
//}
//
