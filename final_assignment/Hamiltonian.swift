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
    //The function takes two integer parameters, m and states, and returns a tuple of three integers. The Swift version uses integer division instead of floor division and the tuple is enclosed in parentheses instead of commas.
        
    //The function first calculates the total number of lattice sites, n, by raising the number of states to the power of three and dividing by two. Then, it calculates the sum s of m and n, and computes the indices h, k, and l by using integer division and modulo operations on s and the number of states. Finally, the function returns the tuple (h, k, l) containing the computed indices.
    // This implementation is Bard on A. Danner (2004)in his implementation of this same problem in Mathematica: http://danner.group/pseudopotential.html
        let n = (states * states * states) / 2
        let s = m + n
        let floor = states / 2
        let h = Double(s / (states * states) - floor)
        let k = Double((s % (states * states)) / states - floor)
        let l = Double(s % states - floor)
        return [h, k, l]
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


    func hamiltonian(latticeConstant: Double, formFactors: [Double: [Double]], reciprocalBasis: [Double], k: [Double], states: Int) -> [[Complex<Double>]] {
        
        let a = latticeConstant
        let ff = formFactors
        let basis = reciprocalBasis
        
        // some constants that don't need to be recalculated
        let kinetic_c = pow(2 * Double.pi / a, 2)
        var offset: [Double] = [0.125, 0.125, 0.125]
        
        // states determines size of matrix
        // each of the three reciprocal lattice vectors can
        // take on this many states, centered around zero
        // resulting in an n^3 x n^3 matrix
        let n = pow(Double(states), 3)
        
        // initialize our matrix to arbitrary elements
        var H = Array(repeating: Array(repeating: Complex<Double>(real: 0.0, imaginary: 0.0), count: Int(N)), count: Int(N))

        
        // iterate over each row and column of the matrix
            for row in 0..<Int(n) {
                for col in 0..<Int(n) {
                    
                    // if row and column index are the same, calculate kinetic energy
                    if row == col {
                        // calculate the reciprocal lattice vector for this row
                        let g = [dot(coefficients(m: row - Int(n / 2), states: states),basis)]
                        // calculate the kinetic energy and assign it to the matrix
                        H[row][col] = Complex<Double>(real: kinetic_c * kinetic(k: k, g: g), imaginary: 0)
                    } else {
                        // calculate the reciprocal lattice vector for this pair of rows and columns
                        let g = [dot(coefficients(m: row - col, states: states), basis)]
                        // get the form factors associated with the magnitude of the reciprocal lattice vector
                        let symfactors = ff[dot(g,g)]
                        let asymfactors = ff[dot(g,g)]
                        // if the form factors exist, calculate the potential energy and assign it to the matrix
                        // otherwise, assign 0 to the matrix
                        H[row][col] = potential(g: g, tau: offset, sym: symfactors![0], asym: asymfactors![0])
                    }
                }
            }
        return H
    }
    
    func dot(_ a: [Double], _ b: [Double]) -> Double {
        return zip(a, b).map(*).reduce(0, +)
    }
    
//    func diagonalizeHamiltonian(hamiltonianMatrix: [[Complex<Double>]]) -> [Complex<Double>] {
//        let n = hamiltonianMatrix.count
//        var matrix_real = [Double](repeating: 0.0, count: n*n)
//        var matrix_imag = [Double](repeating: 0.0, count: n*n)
//        var result_real = [Double](repeating: 0.0, count: n*n)
//        var result_imag = [Double](repeating: 0.0, count: n*n)
//        var eigenvalues_real = [Double](repeating: 0.0, count: n)
//        var eigenvalues_imag = [Double](repeating: 0.0, count: n)
//        var vr = [Double](repeating: 0.0, count: n*n)
//        var vl = [Double](repeating: 0.0, count: n*n)
//        for i in 0..<n {
//            for j in 0..<n {
//                matrix_real[i*n+j] = hamiltonianMatrix[i][j].real
//                matrix_imag[i*n+j] = hamiltonianMatrix[i][j].imaginary
//            }
//        }
//        var jobvl: Int8 = 78 // 'N' to compute only right eigenvectors
//        var jobvr: Int8 = 86 // 'V' to compute both left and right eigenvectors
//        var n_int = __CLPK_integer(n)
//        var lda = n_int
//        var ldvl = n_int
//        var ldvr = n_int
//        var lwork = -1
//        var work_real = [Double](repeating: 0.0, count: 1)
//        var work_imag = [Double](repeating: 0.0, count: 1)
//        var rwork = [Double](repeating: 0.0, count: 2*n)
//        var info: __CLPK_integer = 0
//        zggev_(&jobvl, &jobvr, &n_int, &matrix_real, &lda, &matrix_imag, &lda, &eigenvalues_real, &eigenvalues_imag, &vl, &ldvl, &vr, &ldvr, &work_real, &lwork, &work_imag, &info)
//        lwork = Int(work_real[0])
//        work_real = [Double](repeating: 0.0, count: lwork)
//        work_imag = [Double](repeating: 0.0, count: lwork)
//        zggev_(&jobvl, &jobvr, &n_int, &matrix_real, &lda, &matrix_imag, &lda, &eigenvalues_real, &eigenvalues_imag, &vl, &ldvl, &vr, &ldvr, &work_real, &lwork, &work_imag, &info)
//        var eigenvalues = [Complex<Double>]()
//        for i in 0..<n {
//            eigenvalues.append(Complex<Double>(real: eigenvalues_real[i], imaginary: eigenvalues_imag[i]))
//        }
//        
//        return Array(eigenvalues)
//    }

    
    



    
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
