//
//  Matrix.swift
//  final_assignment
//
//  Created by IIT Phys 440 on 4/27/23.
//

class Matrix {
    let rows: Int
    let columns: Int
    var grid: [[Double]]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.grid = Array(repeating: Array(repeating: 0.0, count: columns), count: rows)
    }
    
    subscript(row: Int, column: Int) -> Double {
        get {
            return grid[row][column]
        }
        set(newValue) {
            grid[row][column] = newValue
        }
    }
}
